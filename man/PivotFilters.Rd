% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PivotFilters.R
\docType{class}
\name{PivotFilters}
\alias{PivotFilters}
\title{A class that defines a set of filter conditions}
\format{\code{\link{R6Class}} object.}
\usage{
PivotFilters
}
\value{
Object of \code{\link{R6Class}} with properties and methods that
  define a set of filter conditions.
}
\description{
The PivotFilters class allows multiple filter conditions relating to
different data frame columns to be combined, i.e. a PivotFilters object can
contain multiple \code{\link{PivotFilter}} objects.
}
\section{Fields}{

\describe{
\item{\code{parentPivot}}{Owning pivot table.}

\item{\code{count}}{The number of PivotFilter objects in this PivotFilters object.}

\item{\code{filters}}{The PivotFilter objects in this PivotFilters object.}

\item{\code{isALL}}{If TRUE, this PivotFilters object matches all data.}

\item{\code{isNONE}}{If TRUE, this PivotFilters object matches no data.}

\item{\code{filteredVariables}}{A list of the variables that are filtered by this
PivotFilters object.}

\item{\code{filteredValues}}{A list of the criteria values for each of the variables
filtered by this PivotFilters object.}
}}

\section{Methods}{

\describe{
  \item{Documentation}{For more complete explanations and examples please see
  the extensive vignettes supplied with this package.}
  \item{\code{new(...)}}{Create a new pivot filters object, specifying the field
  values documented above.}

  \item{\code{clearFilters()}}{Remove all filters.}
  \item{\code{getFilter(variableName=NULL)}}{Find a filter with the specified
  variable name.}
  \item{\code{isFilterMatch(variableNames=NULL, variableValues=NULL)}}{Test
  whether these filters match the specified criteria.}
  \item{\code{setFilters(filters=NULL, action="replace")}}{Update the value of this
  PivotFilters object with the filters from the specified PivotFilters
  object, either unioning, intersecting or replacing the filter criteria.}
  \item{\code{setFilter(filter=NULL, action="replace")}}{Update the value of this
  PivotFilters object with the specified PivotFilter object, either unioning,
  intersecting or replacing the filter criteria.}
  \item{\code{setFilterValues(variableName=NULL, type=NULL, values=NULL,
  action="replace")}}{Update the value of this PivotFilters object with the
  specified criteria, either unioning, intersecting or replacing the filter
  criteria.}
  \item{\code{addFilter()}}{Directly add a PivotFilter object to this
  PivotFilters object.}
  \item{\code{getFilteredDataFrame(dataFrame=NULL)}}{Filters the specified
  data frame and returns the results as another data frame.}
  \item{\code{getCopy()}}{Get a copy of this set of filters.}
  \item{\code{asList()}}{Get a list representation of this PivotFilters
  object.}
  \item{\code{asJSON()}}{Get a JSON representation of this PivotFilters
  object.}
  \item{\code{asString(includeVariableName=TRUE, seperator=", ")}}{Get a text
  representation of this PivotFilters object.}
}
}

\examples{
pt <- PivotTable$new()
# ...
# PivotFilters constructor allows a filter to be defined
filters <- PivotFilters$new(pt, variableName="Year", values=2017)
# Create a new filter
filter <- PivotFilter$new(pt, variableName="Country", values="England")
# Combine the filters
filters$setFilter(filter)
# filters now contains criteria for both Year and Country
# Now add another filter, this time via an alternative method
filters$setFilterValues(variableName="Product", values="Cadbury Dairy Milk
Chocolate 100g")
# filters now contains criteria for Year, Country and Product
}
\keyword{datasets}
