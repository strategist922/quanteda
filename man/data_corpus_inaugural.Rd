% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data-documentation.R
\docType{data}
\name{data_corpus_inaugural}
\alias{data_corpus_inaugural}
\alias{data_char_inaugural}
\title{US presidential inaugural address texts}
\format{a \link{corpus} object with docvars including year, and the last and
  first names of the presidents delivering the inaugural address}
\usage{
data_corpus_inaugural

data_char_inaugural
}
\description{
US presidential inaugural address texts, and metadata (for the corpus), from
1789 to present.
}
\details{
\code{data_corpus_inaugural} is the \link{quanteda-package} corpus 
  object of US presidents' inaugural addresses since 1789. Document variables
  contain the year of the address and the last name of the president.

\code{data_char_inaugural} is the character vector of US presidential inaugaration speeches
}
\examples{
# some operations on the inaugural corpus
summary(data_corpus_inaugural)
head(docvars(data_corpus_inaugural), 10)
# working with the character vector only
str(data_char_inaugural)
head(docvars(data_corpus_inaugural), 10)
mycorpus <- corpus(data_char_inaugural)
}
\references{
\url{https://archive.org/details/Inaugural-Address-Corpus-1789-2009} and 
\url{http://www.presidency.ucsb.edu/inaugurals.php}.
}
\keyword{data}
