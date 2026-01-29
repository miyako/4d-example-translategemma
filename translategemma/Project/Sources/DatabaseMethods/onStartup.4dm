var $llama : cs:C1710.llama.llama

var $homeFolder : 4D:C1709.Folder
$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".GGUF")
var $file : 4D:C1709.File
var $URL : Text
var $port : Integer
var $huggingface : cs:C1710.event.huggingface

var $event : cs:C1710.event.event
$event:=cs:C1710.event.event.new()

$event.onError:=Formula:C1597(ALERT:C41($2.message))
$event.onSuccess:=Formula:C1597(ALERT:C41($2.models.extract("name").join(",")+" loaded!"))
$event.onData:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":"+String:C10((This:C1470.range.end/This:C1470.range.length)*100; "###.00%")))
$event.onData:=Formula:C1597(MESSAGE:C88(This:C1470.file.fullName+":"+String:C10((This:C1470.range.end/This:C1470.range.length)*100; "###.00%")))
$event.onResponse:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":download complete"))
$event.onResponse:=Formula:C1597(MESSAGE:C88(This:C1470.file.fullName+":download complete"))
$event.onTerminate:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; (["process"; $1.pid; "terminated!"].join(" "))))

$port:=8080

$folder:=$homeFolder.folder("translategemma-4b-it")  //where to keep the repo
$path:="translategemma-4b-it-Q4_K_M.gguf"  //path to the file
$URL:="keisuke-miyako/translategemma-4b-it-gguf-q4_k_m"  //path to the repo

$temperature:=0.8  // (default: 0.8)
$ctx_size:=40000
$min_p:=0.1  // (default: 0.1, 0.0 = disabled)
$top_p:=0.9  //(default: 0.9, 1.0 = disabled)
$top_k:=40  //top-k sampling (default: 40, 0 = disabled)
$n_gpu_layers:=-1  //max. number of layers to store in VRAM (default: -1)
$repeat_penalty:=1  //(default: 1.0 = disabled)
$flash_attn:="auto"

$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path)
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$mmproj:=$folder.file("mmproj-model-f16.gguf")

$options:={\
ctx_size: $ctx_size; \
temp: $temperature; \
top_k: $top_k; \
top_p: $top_p; \
min_p: $min_p; \
log_disable: True:C214; \
repeat_penalty: $repeat_penalty; \
n_gpu_layers: $n_gpu_layers; \
flash_attn: $flash_attn; \
mmproj: $mmproj; \
jinja: True:C214}

$llama:=cs:C1710.llama.llama.new($port; $huggingfaces; $homeFolder; $options; $event)