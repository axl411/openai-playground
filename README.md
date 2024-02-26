# openai-playground
Play with OpenAI APIs

First, set up OpenAI API Key in the command line first:
```fish
# Only set API Key for this shell session
set -x OPENAI_API_KEY <API_KEY>
```

Then, run:
```fish
# the executable name should all be "test"
swift run OpenAIPlayground

# or, just open in Xcode. Xcode will inherit the environment variables from the shell session
xed .
```
