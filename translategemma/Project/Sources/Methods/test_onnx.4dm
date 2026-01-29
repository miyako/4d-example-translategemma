//%attributes = {}
$SOURCE_LANG:="English"
$SOURCE_CODE:="en"
$TARGET_LANG:="Spanish"
$TARGET_CODE:="es"
$TEXT:="Hello, how are you?"

var $ChatCompletionsParameters : cs:C1710.AIKit.OpenAIChatCompletionsParameters
$ChatCompletionsParameters:=cs:C1710.AIKit.OpenAIChatCompletionsParameters.new({model: ""})

$messages:=[]
$messages.push({role: "user"; content: [\
{type: "text"; \
source_lang_code: $SOURCE_CODE; \
target_lang_code: $TARGET_CODE; \
text: $TEXT}]})

var $OpenAI : cs:C1710.AIKit.OpenAI
$OpenAI:=cs:C1710.AIKit.OpenAI.new({baseURL: "http://127.0.0.1:8080/v1"})

var $ChatCompletionsResult : cs:C1710.AIKit.OpenAIChatCompletionsResult
$ChatCompletionsResult:=$OpenAI.chat.completions.create($messages; $ChatCompletionsParameters)
If ($ChatCompletionsResult.success)
	ALERT:C41($ChatCompletionsResult.choice.message.text)
End if 