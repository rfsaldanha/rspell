text_string <- "O rato roeu a roupa do rei de roma."

test_that("expect error if text is not set", {
  expect_error(check_text(text = NULL))
})

test_that("expect error if text is not character", {
  expect_error(check_text(text = TRUE))
})

test_that("expect error if language is not set", {
  expect_error(check_text(text = text_string, language = NULL))
})

test_that("expect error if language is not set", {
  expect_error(check_text(text = text_string, language = NULL))
})

test_that("expect error if language if not supported", {
  expect_error(check_text(text = text_string, language = "blabla"))
})

test_that("expect a tibble as responde", {
  expect_true(tibble::is_tibble(check_text(text = text_string, language = "pt-BR")))
})
