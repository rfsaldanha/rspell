# rspell

This package aims to provide grammar check in R, specially for RStudio users editing notebooks. As some tools like Grammarly and LanguageTools are not (yet) directly integrated to the IDE, this is a temporary solution.

`rspell` uses the [LanguageTool API](https://languagetool.org/http-api/) and can verify grammar for several languages and was inspired by the [`ggspell`](https://github.com/nicucalcea/ggspell)package.

## Usage

First, install the package.

```{r eval=FALSE}
remotes::install_github("rfsaldanha/rspell")
```

Then, select some text on your notebook and run the `check_selection` command.

```{r eval=FALSE}
rspell::check_selection()
```

At the console, possible grammar errors will be shown, and you will be asked to modify or not the text. The LanguageTool API will automatically try to discover your text language.

## Add-in and keyboard shortcut

For a faster use, you can use the package's RStudio add-in. After installing the package, it will be available at the add-in list. You can also map a [keyboard shortcut](https://support.posit.co/hc/en-us/articles/206382178-Customizing-Keyboard-Shortcuts-in-the-RStudio-IDE) for it, like `Ctrl+g`.

## More options

It is possible to just show the errors without asking to modificate the selection.

```{r eval=FALSE}
rspell::check_selection(ask_modify = FALSE)
```

And to specify the language ([available options](https://api.languagetoolplus.com/v2/languages) at the API).

```{r eval=FALSE}
rspell::check_selection(language = "FR")
```