% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ranef.R
\name{ranef.mires}
\alias{ranef.mires}
\alias{ranef}
\title{Extract random effects of each group from MIRES model.}
\usage{
\method{ranef}{mires}(object, prob = 0.95, ...)
}
\arguments{
\item{object}{mires object.}

\item{prob}{Numeric (Default: .95). Amount of probability mass to contain within the credible interval.}

\item{...}{Not used.}
}
\value{
List containing summaries of lambda, (log) residual SDs, nu, latent mean, and (log) latent SD random effects.
}
\description{
Extract random effects of each group from MIRES model.
}
\author{
Stephen R Martin
}
