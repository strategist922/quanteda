context("test dfm_select")

txt <- c(doc1 = "a B c D e",
         doc2 = "a BBB c D e",
         doc3 = "Aaaa BBB cc")
testdfm <- dfm(txt, tolower = FALSE)

test_that("test dfm_select, fixed", {
    expect_equal(
        featnames(dfm_select(testdfm, c("a", "b", "c"), selection = "keep", valuetype = "fixed", verbose = FALSE)),
        c("a", "B", "c")
    )
    expect_equal(
        featnames(dfm_select(testdfm, c("a", "b", "c"), selection = "remove", valuetype = "fixed", verbose = FALSE)),
        setdiff(featnames(testdfm), c("a", "B", "c"))
    )
    expect_equal(
        featnames(dfm_select(testdfm, c("a", "b", "c"), selection = "keep", valuetype = "fixed", case_insensitive = FALSE, verbose = FALSE)),
        c("a", "c")
    )
    expect_equal(
        featnames(dfm_select(testdfm, c("a", "b", "c"), selection = "remove", valuetype = "fixed", case_insensitive = FALSE, verbose = FALSE)),
        setdiff(featnames(testdfm), c("a", "c"))
    )
    expect_equal(
        featnames(dfm_select(testdfm, c("aaaa", "bbb", "cc"), selection = "keep", valuetype = "fixed", min_nchar = 3, verbose = FALSE)),
        c("BBB", "Aaaa")
    )
    expect_equal(
        featnames(dfm_select(testdfm, c("bbb"), selection = "remove", valuetype = "fixed", min_nchar = 3, verbose = FALSE)),
        c("Aaaa")
    )
    expect_equal(
        featnames(dfm_select(testdfm, c("aaaa", "bbb", "cc"), selection = "keep", valuetype = "fixed", min_nchar = 3, max_nchar = 3, verbose = FALSE)),
        c("BBB")
    )
    expect_equal(
        featnames(dfm_select(testdfm, c("bbb"), selection = "remove", valuetype = "fixed", min_nchar = 3, max_nchar = 3, verbose = FALSE)),
        character()
    )
})

test_that("test dfm_select, glob", {
    feats <- c("a*", "B*", "c")
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "keep", valuetype = "glob", verbose = FALSE)),
        c("a", "B", "c", "BBB", "Aaaa")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "remove", valuetype = "glob", verbose = FALSE)),
        c( "D", "e", "cc")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "keep", valuetype = "glob", case_insensitive = FALSE, verbose = FALSE)),
        c("a", "B", "c", "BBB")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "remove", valuetype = "glob", case_insensitive = FALSE, verbose = FALSE)),
        c("D", "e", "Aaaa", "cc")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "keep", valuetype = "glob", min_nchar = 3, verbose = FALSE)),
        c("BBB", "Aaaa")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "remove", valuetype = "glob", min_nchar = 3, verbose = FALSE)),
        character()
    )
})

test_that("test dfm_select, regex", {
    feats <- c("[A-Z].*", "c.+")
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "keep", valuetype = "regex", verbose = FALSE)),
        c("a", "B", "c", "D", "e", "BBB", "Aaaa", "cc")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "remove", valuetype = "regex", verbose = FALSE)),
        character()
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "keep", valuetype = "regex", case_insensitive = FALSE, verbose = FALSE)),
        c("B", "D", "BBB", "Aaaa", "cc")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "remove", valuetype = "regex", case_insensitive = FALSE, verbose = FALSE)),
        c("a", "c", "e")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "keep", valuetype = "regex", min_nchar = 3, verbose = FALSE)),
        c("BBB", "Aaaa")
    )
    expect_equal(
        featnames(dfm_select(testdfm, feats, selection = "remove", valuetype = "regex", min_nchar = 3, verbose = FALSE)),
        character()
    )
})

test_that("glob works if results in no features", {
    expect_equal(featnames(dfm_select(testdfm, "notthere")), character())
})

test_that("featnames.NULL, docnames.NULL works as expected", {
    expect_equal(featnames(NULL), NULL)
    expect_equal(docnames(NULL), NULL)
})

test_that("selection that is out of bounds", {
    expect_equal(dfm_select(testdfm), testdfm)
    
    expect_equal(
        featnames(dfm_select(testdfm, selection = "keep", min_nchar = 5)),
        character()
    )      

    expect_equal(
        featnames(dfm_select(testdfm, selection = "remove", min_nchar = 5)),
        character()
    )

    # some tests for docnames and featnames
    expect_equal(docnames(NULL), NULL)
    expect_equal(featnames(NULL), NULL)
})

test_that("longer selection than longer than features that exist (related to #447)", {
    dfmtest <- dfm(tokens(c(d1 = 'a b', d2 = 'a b c d e')))
    feat <- c('b', 'c', 'd', 'e', 'f', 'g')
    # bugs in C++ needs repeated tests
    expect_message(dfm_select(dfmtest, feat, verbose = TRUE),
                   "dfm_select kept 4 features in 2 documents*")
    expect_equivalent(
        as.matrix(dfm_select(dfmtest, feat)),
        matrix(c(1, 1, 0, 1, 0, 1, 0, 1), nrow = 2)
    )
})


test_that("test dfm_select with ngrams #589", {
    
    ngramdfm <- dfm(c('of_the', 'in_the', 'to_the', 'of_our', 'and_the', ' it_is', 'by_the', 'for_the'))
    expect_equal(featnames(dfm_select(ngramdfm, features = c('of_the', 'in_the'), valuetype = 'fixed')),
                 c('of_the', 'in_the'))
    expect_equal(featnames(dfm_select(ngramdfm, features = '*_the', valuetype = 'glob')),
                 c('of_the', 'in_the', 'to_the', 'and_the', 'by_the', 'for_the'))
    
})

test_that("test dfm_select with documents", {
    
    expect_equal(docnames(dfm_select(testdfm, documents = 'doc*', selection = "keep", valuetype = "glob", 
                                     padding = FALSE, verbose = FALSE, case_insensitive = FALSE)),
                 c('doc1', 'doc2', 'doc3'))
    
    expect_equal(docnames(dfm_select(testdfm, documents = c('doc1', 'doc2'), selection = "keep", valuetype = "fixed", 
                                    padding = FALSE, verbose = FALSE, case_insensitive = FALSE)),
                 c('doc1', 'doc2'))
    
    expect_equal(docnames(dfm_select(testdfm, documents = c('doc1', 'doc2'), selection = "remove", valuetype = "fixed", 
                                     padding = FALSE, verbose = FALSE, case_insensitive = FALSE)),
                 c('doc3'))
    
    expect_equal(docnames(dfm_select(testdfm, documents = c('doc3', 'doc4'), selection = "keep", valuetype = "fixed", 
                                     padding = TRUE, verbose = FALSE, case_insensitive = FALSE)),
                 c('doc3', 'doc4'))
})

test_that("test dfm_select with dates in document names", {
    
    dates <- as.character(seq.Date(as.Date('2017-01-01'), as.Date('2017-12-31'), 1))
    txts <- paste('text', seq_along(dates))
    names(txts) <- dates
    paddeddfm <- dfm_select(dfm(txts)[1:10,], documents = dates, valuetype = 'fixed', padding = TRUE)
    expect_equal(ndoc(paddeddfm), 365)
    
})


test_that("test dfm_select with features from a dfm,  fixed", {
    txt <- c(doc1 = "a B c D e",
             doc2 = "a BBB c D e",
             doc3 = "Aaaa BBB cc")
    testdfm <- dfm(txt, tolower = FALSE)  
    expect_equal(
        colSums(dfm_select(testdfm, dfm(c("a", "b", "c")), case_insensitive = TRUE, min_nchar = 1)),
        c(a = 2, b = 0, c = 2)
    )
    expect_equal(
        colSums(dfm_select(testdfm, dfm(c("a", "b", "c")), case_insensitive = FALSE, min_nchar = 1)),
        c(a = 2, b = 0, c = 2)
    )
    
    expect_equal(
        colSums(dfm_select(testdfm, dfm(c("a", "b", "c")), min_nchar = 1)),
        c(a=2, b = 0, c=2)
    )
})


test_that("dfm_select returns equal feature sets", {
    txts <- c(d1 = "This is text one", d2 = "The second text", d3 = "This is text three")
    dfm1 <- dfm(txts[1:2])
    dfm2 <- dfm(txts[2:3])
    dfm3 <- dfm_select(dfm1, dfm2)
    expect_true(setequal(featnames(dfm2), featnames(dfm3)))
})

test_that("dfm_select removes padding", {
    
    txts <- c(d1 = "This is text one", d2 = "The second text", d3 = "This is text three")
    toks <- tokens(txts)
    toks <- tokens_remove(toks, stopwords(), padding = TRUE)
    testdfm <- dfm(toks)
    expect_true('' %in% featnames(testdfm))
    testdfm <- dfm_remove(dfm(toks), '')
    expect_false('' %in% featnames(testdfm))
    
})

test_that("dfm_select raises warning when padding = TRUE but not valuetype = fixed", {
    
  expect_warning(dfm_select(testdfm, c('z', 'd', 'e'), padding = TRUE),
                 "padding is used only when valuetype is 'fixed'")
    
})

test_that("dfm_select return empty dfm when not maching features", {
    
    expect_equal(dim(dfm_select(testdfm, features = c('x', 'y', 'z'), documents = 'doc4')),
                 c(0, 0))
    
    expect_equal(print(dfm_select(testdfm, features = c('x', 'y', 'z'))),
                 NULL)
})






