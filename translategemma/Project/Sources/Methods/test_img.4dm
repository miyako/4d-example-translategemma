//%attributes = {}
$SOURCE_LANG:="English"
$SOURCE_CODE:="en"
$TARGET_LANG:="Spanish"
$TARGET_CODE:="es"
$text:=""
$data:=File:C1566("/RESOURCES/sample.png").getContent()
BASE64 ENCODE:C895($data; $text)
$url:="data:image/png;base64,"+$text

$chat_template:="You are a professional "+\
"$4dtext($1.SOURCE_LANG) ($4dtext($1.SOURCE_CODE)) "+\
"to $4dtext($1.TARGET_LANG) ($4dtext($1.TARGET_CODE)) translator. "+\
"Your goal is to accurately convey the meaning and nuances of the original "+\
"$4dtext($1.SOURCE_LANG) text while adhering to $4dtext($1.TARGET_LANG) "+\
"grammar, vocabulary, and cultural sensitivities.\n"+\
"Please translate the $4dtext($1.SOURCE_LANG) text in the provided image into $4dtext($1.TARGET_LANG)."+\
"Produce only the $4dtext($1.TARGET_LANG) translation, "+\
"without any additional explanations or commentary."+\
"Focus only on the text, do not output where the text is located, "+\
"surrounding objects or any other explanation about the picture. "+\
"Ignore symbols, pictogram, and arrows!"

PROCESS 4D TAGS:C816($chat_template; $content; {\
SOURCE_LANG: $SOURCE_LANG; \
SOURCE_CODE: $SOURCE_CODE; \
TARGET_LANG: $TARGET_LANG; \
TARGET_CODE: $TARGET_CODE})

var $ChatCompletionsParameters : cs:C1710.AIKit.OpenAIChatCompletionsParameters
$ChatCompletionsParameters:=cs:C1710.AIKit.OpenAIChatCompletionsParameters.new({model: ""})

//%W-550.26
$ChatCompletionsParameters.stop:=["<|file_ref|>"; "<|file_separator|>"]
//%W+550.26

$ChatCompletionsParameters.body:=Formula:C1597($0:={\
stop: This:C1470.stop; \
temperature: This:C1470.temperature; \
n: This:C1470.n})

$messages:=[]
$messages.push({role: "user"; content: [\
{type: "text"; text: $content}; \
{type: "image_url"; image_url: {url: $url}}]})

var $OpenAI : cs:C1710.AIKit.OpenAI
$OpenAI:=cs:C1710.AIKit.OpenAI.new({baseURL: "http://127.0.0.1:8080/v1"})

var $ChatCompletionsResult : cs:C1710.AIKit.OpenAIChatCompletionsResult
$ChatCompletionsResult:=$OpenAI.chat.completions.create($messages; $ChatCompletionsParameters)
If ($ChatCompletionsResult.success)
	ALERT:C41($ChatCompletionsResult.choice.message.text)
End if 