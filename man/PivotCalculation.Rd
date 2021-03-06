% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PivotCalculation.R
\docType{class}
\name{PivotCalculation}
\alias{PivotCalculation}
\title{A class that defines a calculation.}
\format{\code{\link{R6Class}} object.}
\usage{
PivotCalculation
}
\value{
Object of \code{\link{R6Class}} with properties and methods that
  define a single pivot table calculation.
}
\description{
The PivotCalculation class defines one calculation in a pivot table.
}
\section{Fields}{

\describe{
\item{\code{parentPivot}}{Owning pivot table.}

\item{\code{calculationName}}{Calculation unique name.}

\item{\code{caption}}{Calculation display name - i.e. the name shown in the pivot
table.}

\item{\code{visible}}{Show or hide the calculation.  Hidden calculations are
typically used as base values for other calculations.}

\item{\code{displayOrder}}{The order the calculations are displayed in the pivot
table.}

\item{\code{filters}}{Any additional data filters specific to this calculation.
This can be a PivotFilters object that further restrict the data for the
calculation of a list of individual PivotFilter objects that provide more
flexibility (and/or/replace).  See the Calculations vignette for details.}

\item{\code{format}}{A character, list or custom function to format the calculation
result.}

\item{\code{dataName}}{Specifies which data frame in the pivot table is used for
this calculation.}

\item{\code{type}}{The calculation type:  "summary", "calculation", "function" or
"value".}

\item{\code{valueName}}{For type="value", the name of the column containing the
value to display in the pivot table.}

\item{\code{summariseExpression}}{For type="summary", either the dplyr expression to
use with dplyr::summarise() or a data.table calculation expression.}

\item{\code{calculationExpression}}{For type="calculation", an expression to combine
aggregate values.}

\item{\code{calculationFunction}}{For type="function", a reference to a custom R
function that will carry out the calculation.}

\item{\code{basedOn}}{A character vector specifying the names of one or more
calculations that this calculation depends on.}

\item{\code{noDataValue}}{An integer or numeric value specifying the value to use if
no data exists for a particular cell.}

\item{\code{noDataCaption}}{A character value that will be displayed by the pivot
table if no  data exists for a particular cell.}
}}

\section{Methods}{

\describe{
  \item{Documentation}{For more complete explanations and examples please see
  the extensive vignettes supplied with this package.}
  \item{\code{new(...)}}{Create a new pivot calculation, specifying the field
  values documented above.}

  \item{\code{asList()}}{Get a list representation of this calculation.}
  \item{\code{asJSON()}}{Get a JSON representation of this calculation.}
  \item{\code{asString()}}{Get a text representation of this calculation.}
}
}

\examples{
# This class should only be created by the pivot table.
# It is not intended to be created outside of the pivot table.
}
\keyword{datasets}
