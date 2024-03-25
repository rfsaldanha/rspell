# rspell 0.0.6

* New function `get_languages()` to get a tibble with LanguageTool's API supported languages. 
* Validates language argument on functions. 
* Internal test functions.

# rspell 0.0.5

* Function `check_text()` in now exported.
* Improve messages.
* Modify internal function names.

# rspell 0.0.4

* Improve documentation and arguments assertion.

# rspell 0.0.3

* Primarily, adopt the spelling language defined on RStudio's Project Options. If not defined, uses the spelling language from Global options.
* Verifies the text size accordingly to LanguageTool API rules (20KB maximum size).
* Ignore case on looking for rproj files.

# rspell 0.0.2

* Prompt to modify text with default choice (just press Enter).
* Move focus to console and back to source.
* Messages improvements.
* Do not query LanguageTool API if selection is empty.
* Do not use query cache on API call.
* Throttle requests rate accordingly to LanguageTool API rules (20 requests per minute).

# rspell 0.0.1

* The package now observes if there is a default project language set.

# rspell 0.0.0.9

* First version, basic functions.
