//%attributes = {}
$SOURCE_LANG:="English"
$SOURCE_CODE:="en"
$TARGET_LANG:="Spanish"
$TARGET_CODE:="es"
$TEXT:="Hello, how are you?"

$chat_template:="You are a professional "+\
"$4dtext($1.SOURCE_LANG) ($4dtext($1.SOURCE_CODE)) "+\
"to $4dtext($1.TARGET_LANG) ($4dtext($1.TARGET_CODE)) translator. "+\
"Your goal is to accurately convey the meaning and nuances of the original "+\
"$4dtext($1.SOURCE_LANG) text while adhering to $4dtext($1.TARGET_LANG) "+\
"grammar, vocabulary, and cultural sensitivities.\n"+\
"Produce only the $4dtext($1.TARGET_LANG) translation, "+\
"without any additional explanations or commentary. "+\
"Please translate the following $4dtext($1.SOURCE_LANG) text "+\
"into $4dtext($1.TARGET_LANG):\n\n$4dtext($1.TEXT)"

PROCESS 4D TAGS:C816($chat_template; $content; {\
SOURCE_LANG: $SOURCE_LANG; \
SOURCE_CODE: $SOURCE_CODE; \
TARGET_LANG: $TARGET_LANG; \
TARGET_CODE: $TARGET_CODE; TEXT: $TEXT})

var $ChatCompletionsParameters : cs:C1710.AIKit.OpenAIChatCompletionsParameters
$ChatCompletionsParameters:=cs:C1710.AIKit.OpenAIChatCompletionsParameters.new({model: ""})

$messages:=[]
$messages.push({role: "user"; content: $content})

var $OpenAI : cs:C1710.AIKit.OpenAI
$OpenAI:=cs:C1710.AIKit.OpenAI.new({baseURL: "http://127.0.0.1:8080/v1"})

var $ChatCompletionsResult : cs:C1710.AIKit.OpenAIChatCompletionsResult
$ChatCompletionsResult:=$OpenAI.chat.completions.create($messages; $ChatCompletionsParameters)
If ($ChatCompletionsResult.success)
	ALERT:C41($ChatCompletionsResult.choice.message.text)
End if 