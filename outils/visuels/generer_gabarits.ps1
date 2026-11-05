#Requires -Version 7
# Génère les gabarits .vctemplate des tuiles (cotes : voir STYLE.md §1 et §3) en pilotant
# vectorcraft-cli par son serveur MCP. Les polices Inter et Segoe UI Emoji doivent être installées.
#
#   pwsh outils/visuels/generer_gabarits.ps1 [-OutDir <dossier>] [-PreviewDir <dossier>] [-Exe <chemin>]
#
# -PreviewDir ajoute, pour chaque gabarit, un export PNG à 300 dpi.
param(
  [string]$OutDir = (Join-Path $PSScriptRoot 'gabarits'),
  [string]$PreviewDir,
  [string]$Exe = 'C:\Program Files\ArtCraft\VectorCraft\vectorcraft-cli.exe'
)
$ErrorActionPreference = 'Stop'
$null = New-Item -ItemType Directory -Force $OutDir
$OutDir = (Resolve-Path $OutDir).Path
if ($PreviewDir) { $null = New-Item -ItemType Directory -Force $PreviewDir }

$utf8 = [System.Text.UTF8Encoding]::new($false)
$psi = [System.Diagnostics.ProcessStartInfo]::new($Exe)
foreach ($a in 'mcp','--automation-read-root',$OutDir,'--automation-write-root',$OutDir) { $psi.ArgumentList.Add($a) }
$psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true
$psi.UseShellExecute = $false; $psi.StandardInputEncoding = $utf8; $psi.StandardOutputEncoding = $utf8
$p = [System.Diagnostics.Process]::Start($psi)
$null = $p.StandardError.ReadToEndAsync()
$script:rpc = 0

function Rpc($method, $params) {
  $script:rpc++
  $p.StandardInput.WriteLine((@{ jsonrpc='2.0'; id=$script:rpc; method=$method; params=$params } | ConvertTo-Json -Depth 20 -Compress))
  $p.StandardInput.Flush()
  while ($true) {
    $t = $p.StandardOutput.ReadLineAsync()
    if (-not $t.Wait(60000)) { throw "timeout sur $method" }
    $m = $t.Result | ConvertFrom-Json -Depth 30
    if ($m.id -eq $script:rpc) { break }
  }
  if ($m.error) { throw "$method : $($m.error.message)" }
  return $m.result
}
function Tool($name, $arguments) {
  $r = Rpc 'tools/call' @{ name=$name; arguments=$arguments }
  $txt = ($r.content | Where-Object type -eq 'text' | Select-Object -First 1).text
  if ($r.isError) { throw "$name : $txt" }
  if ($txt) { try { return $txt | ConvertFrom-Json -Depth 30 } catch { return $txt } }
  return $r
}
function Cmd($id, $params = @{}) { Tool 'command_run' @{ id=$id; params=$params } }
function M([double]$v) { [math]::Round($v * 72 / 25.4, 4) }

function Layer($name) {
  $l = Cmd 'layer.new' @{ name=$name; top=$true }
  $null = Cmd 'layer.setCurrent' @{ id=$l.id }
  return $l.id
}
function Rect($name, $x, $y, $w, $h, $fill, $stroke = 'none', $radius = 0, $sw = 0.5, $dash = $null) {
  $a = @{ shape='rectangle'; name=$name; x=(M $x); y=(M $y); width=(M $w); height=(M $h); fill=$fill; stroke=$stroke }
  if ($radius) { $a.radius = (M $radius) }
  if ($stroke -ne 'none') { $a.strokeWidth = $sw }
  if ($dash) { $a.dash = $dash }
  (Tool 'draw_shape' $a).id
}
function Label($text, $cx, $baseline, $size = 6.5, $color = '#37474F') {
  $null = Cmd 'text.create' @{ x=(M $cx); y=(M $baseline); text=$text; size=$size; font='Inter'; style='Medium'; color=$color; justify='center' }
}
# Titre en texte captif : reste dans son cadre (réduction auto) et se remplace sans toucher au gabarit.
function Title($x, $w, $top, $h, $size, $color, $justify, $vcenter = $false) {
  $r = Cmd 'text.create' @{ x=(M $x); y=(M $top); text='TITRE'; size=$size; font='Inter'; style='SemiBold'; color=$color; justify=$justify
    area=@{ width=(M $w); height=(M $h); fit='shrinkText'; fitMinPercent=50 } }
  if ($r.warning) { Write-Warning "titre : $($r.warning)" }
  if ($vcenter) { $null = Cmd 'text.areaOptions' @{ id=$r.id; verticalAlign='center' } }
  $null = Cmd 'object.setProps' @{ id=$r.id; name='Titre (à remplacer)' }
}
function Pastille($cx, $cy, $d) {
  $parent = Layer 'Pastille de spécialité'
  $specs = @(
    @('paranormal','#37474F','👻'), @('orthopedie','#EF6C00','🦴'), @('psychiatrie','#7B4FBF','🧠'),
    @('cardiologie','#C62828','❤️'), @('generale','#1565C0','🩺'))
  foreach ($s in $specs) {
    $sub = Cmd 'layer.newSublayer' @{ parent=$parent; name=$s[0]; visible=($s[0] -eq 'generale') }
    $null = Cmd 'layer.setCurrent' @{ id=$sub.id }
    $null = Tool 'draw_shape' @{ shape='ellipse'; name="Pastille $($s[0])"; x=(M ($cx-$d/2)); y=(M ($cy-$d/2)); width=(M $d); height=(M $d); fill=$s[1]; stroke='#FFFFFF'; strokeWidth=1 }
    $size = $d * 72 / 25.4 * 0.56
    $r = Cmd 'text.create' @{ x=(M $cx); y=((M $cy) + $size*0.36); text=$s[2]; size=$size; font='Segoe UI Emoji'; color='#FFFFFF'; justify='center' }
    $null = Cmd 'object.setProps' @{ id=$r.id; name="Icône $($s[0])" }
  }
  return $parent
}

function Build($d) {
  $w = $d.w; $h = $d.h
  $null = Cmd 'file.new' @{ name=$d.file; width=(M $w); height=(M $h); units='Millimeters'; bleed=(M 3); colorMode='rgb'; rasterEffectsPpi=300 }
  $info = Tool 'doc_inspect' @{ depth=0 }
  $base = $info.layers[0].id
  $null = Cmd 'layer.setProps' @{ id=$base; name='Fond' }
  $null = Cmd 'layer.setCurrent' @{ id=$base }
  $null = Rect 'Fond avec fond perdu' -3 -3 ($w+6) ($h+6) '#FAFAFA'

  $null = Layer 'Illustration (zone variable)'
  $null = Rect 'Zone illustration' $d.illu[0] $d.illu[1] $d.illu[2] $d.illu[3] '#ECEFF1'

  $null = Layer 'Liseré'
  $o = Rect 'Liseré ext' -3 -3 ($w+6) ($h+6) $d.color
  $i = Rect 'Liseré int' 1.5 1.5 ($w-3) ($h-3) '#FFFFFF' 'none' 1.5
  $null = Tool 'pathfinder' @{ operation='minusFront'; ids=@($o,$i) }
  $null = Cmd 'object.setProps' @{ name='Liseré du type (1,5 mm)' }

  $null = Layer 'Bandeau titre'
  $null = Rect 'Bandeau' -3 -3 ($w+6) ($d.band+3) $d.color

  if ($d.slots) {
    $null = Layer 'Logements (sous-épaisseur 2 mm)'
    foreach ($s in $d.slots) { $null = Rect $s.name $s.x $s.y $s.w $s.h '#CFD8DC' $d.color 0 0.75 @(4,2.5) }
  }

  $null = Layer 'Titre'
  Title $d.title.x $d.title.w $d.title.top $d.title.h $d.title.size $d.titleColor $d.title.justify $d.title.vcenter

  $null = Layer 'QR code'
  $null = Rect "QR $($d.qr[2]) x $($d.qr[2]) mm (généré par planche_qr)" $d.qr[0] $d.qr[1] $d.qr[2] $d.qr[2] '#FFFFFF' '#90A4AE'

  $past = $null
  if ($d.pastille) { $past = Pastille $d.pastille[0] $d.pastille[1] $d.pastille[2] }
  if ($past -and $d.pastilleHidden) { $null = Cmd 'layer.setProps' @{ id=$past; visible=$false } }

  $marks = Layer 'Repères (non imprimés)'
  $null = Rect 'Coupe (coins r = 3 mm)' 0 0 $w $h 'none' '#E91E63' 3 0.5 @(3,2)
  $null = Rect 'Zone sûre (5 mm depuis le bord du fond perdu)' 2 2 ($w-4) ($h-4) 'none' '#00ACC1' 0 0.35 @(1.5,1.5)
  foreach ($l in $d.labels) { Label $l[0] $l[1] $l[2] $l[3] }
  $null = Cmd 'layer.setProps' @{ id=$marks; template=$true }

  $null = Tool 'save_file' @{ path=(Join-Path $OutDir "$($d.file).vctemplate"); preview=$true }
  if ($PreviewDir) {
    $e = Tool 'export' @{ format='png'; scale=(300/72) }
    [IO.File]::WriteAllBytes((Join-Path $PreviewDir "$($d.file)_300dpi.png"), [Convert]::FromBase64String($e.dataBase64))
  }
  Write-Output "$($d.file) : $w x $h mm"
}

$null = Rpc 'initialize' @{ protocolVersion='2025-06-18'; capabilities=@{}; clientInfo=@{ name='generer_gabarits'; version='1' } }
$p.StandardInput.WriteLine('{"jsonrpc":"2.0","method":"notifications/initialized"}'); $p.StandardInput.Flush()

# Toutes les cotes ci-dessous sont en mm, depuis le coin haut gauche de la coupe.
# Tuile portrait 60 x 85 : bandeau 10, illustration 60 x 50, QR 20 + pastille sur la bande basse de 25 mm.
function Portrait($file, $color, $hidden) {
  @{ file=$file; w=60; h=85; band=10; color=$color; titleColor='#FFFFFF'
     illu=@(0,10,60,50); qr=@(37.5,62.5,20); pastille=@(28.5,72.5,14); pastilleHidden=$hidden
     title=@{ x=2; w=56; top=2; h=8; size=14; justify='center' }
     labels=@(@('ILLUSTRATION 60 × 50 mm',30,36,6.5), @('QR 20 × 20 mm',47.5,73.5,5.5)) }
}
# Tuile carrée 45 x 45 : un QR de 20 mm chevaucherait l'illustration 25 x 17, d'où le QR de 15 mm prévu au §3.2.
function Carre($file, $color, $titleColor) {
  @{ file=$file; w=45; h=45; band=8; color=$color; titleColor=$titleColor
     illu=@(10,9,25,17); qr=@(27.5,27.5,15)
     title=@{ x=2; w=41; top=1.44; h=6.56; size=12; justify='center' }
     labels=@(@('ILLUSTRATION 25 × 17',22.5,18.3,5), @('QR 15 mm',35,36,5)) }
}
# Salles : médecins et patients en portrait, mêmes 122 mm de haut = bandeau 22 + 7 + logement 86 + 7.
# Encoches latérales ouvertes sur 86 mm, profondeur 20 mm : la tuile de 60 mm dépasse de 40 mm (deux tiers).
$salle = @{ file='gabarit_salle'; w=100; h=122; band=22; color='#455A64'; titleColor='#FFFFFF'
  illu=@(20,69,60,51.5); qr=@(75,2,20)
  title=@{ x=5; w=65; top=2; h=18; size=20; justify='left'; vcenter=$true }
  slots=@(
    @{ name='Encoche médecin 86 x 20 mm (portrait)'; x=-3; y=29; w=23; h=86 },
    @{ name='Encoche patient 86 x 20 mm (portrait)'; x=80; y=29; w=23; h=86 },
    @{ name='Logement objet/diplôme 46 x 46 mm'; x=27; y=22.5; w=46; h=46 })
  labels=@(
    @('MÉDECIN',10,71,6), @('86 × 20 mm',10,75,6), @('PATIENT',90,71,6), @('86 × 20 mm',90,75,6),
    @('OBJET / DIPLÔME 46 × 46 mm',50,46.3,6.5), @('ILLUSTRATION ~60 × 50 mm',50,96,6.5), @('QR 20 × 20 mm',85,12.8,5.5)) }
# Bloc = salle standard + logement patient 61 x 86 mm et 7 mm d'écart : 20 + 7 + 61 + 7 + 46 + 7 + 20 = 168 mm.
$bloc = @{ file='gabarit_bloc'; w=168; h=122; band=22; color='#455A64'; titleColor='#FFFFFF'
  illu=@(88,69,60,51.5); qr=@(143,2,20)
  title=@{ x=5; w=133; top=2; h=18; size=20; justify='left'; vcenter=$true }
  slots=@(
    @{ name='Encoche médecin gauche 86 x 20 mm (portrait)'; x=-3; y=29; w=23; h=86 },
    @{ name='Encoche médecin droite 86 x 20 mm (portrait)'; x=148; y=29; w=23; h=86 },
    @{ name='Logement patient 61 x 86 mm (portrait)'; x=27; y=29; w=61; h=86 },
    @{ name='Logement objet/diplôme 46 x 46 mm'; x=95; y=22.5; w=46; h=46 })
  labels=@(
    @('MÉDECIN',10,71,6), @('86 × 20 mm',10,75,6), @('MÉDECIN',158,71,6), @('86 × 20 mm',158,75,6),
    @('PATIENT 61 × 86 mm',57.5,73,6.5), @('OBJET / DIPLÔME 46 × 46 mm',118,46.3,6.5),
    @('ILLUSTRATION ~60 × 50 mm',118,96,6.5), @('QR 20 × 20 mm',153,12.8,5.5)) }

$docs = @(
  (Portrait 'gabarit_medecin' '#0D47A1' $false),
  (Portrait 'gabarit_patient' '#BF360C' $true),
  (Carre 'gabarit_objet' '#8D6E63' '#FFFFFF'),
  (Carre 'gabarit_diplome' '#C9A227' '#212121'),
  $salle, $bloc)
try { foreach ($d in $docs) { Build $d } }
finally { try { $p.StandardInput.Close() } catch {}; if (-not $p.WaitForExit(5000)) { $p.Kill() } }
