#' A class that defines a set of filter overrides
#'
#' The PivotFilterOverrides class contains multiple  \code{\link{PivotFilter}}
#' objects that can be used later to override a set of filters, e.g. in a
#' pivot table calculation.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @import jsonlite
#' @export
#' @return Object of \code{\link{R6Class}} with properties and methods that
#'   define a set of filters and associated override actions
#' @format \code{\link{R6Class}} object.
#' @examples
#' pt <- PivotTable$new()
#' # ...
#' # PivotFilterOverrides constructor allows a filter to be defined
#' # e.g. to enable %of row or column type calculations
#' filterOverrides <- PivotFilterOverrides$new(pt, keepOnlyFiltersFor="Volume")
#' # Alternatively/in addition, create a new filter
#' filter <- PivotFilter$new(pt, variableName="Country", values="England")
#' # Add the filter to the set of overrides
#' filterOverrides$add(filter=filter, action="replace")
#' @field parentPivot Owning pivot table.
#' @field removeAllFilters TRUE to remove all existing filters before applying
#' any other and/replace/or filters.
#' @field keepOnlyFiltersFor Specify the names of existing variables to retain
#' the filters for.  All other filters will be removed.
#' @field removeFiltersFor Specify the names of variables to remove filters for.
#' @field overrideFunction A custom function to amend the filters in each cell.
#' @field countIntersect The number of PivotFilters that will be combined with other
#' pivot filters by intersecting their lists of allowed values.
#' @field countReplace The number of PivotFilters that will be combined with other
#' pivot filters by entirely replacing existing PivotFilter objects.
#' @field countUnion The number of PivotFilters that will be combined with other
#' pivot filters by unioning their lists of allowed values.
#' @field countTotal The total number of PivotFilters that will be combined with
#' other pivot filters.
#' @field intersectFilters The PivotFilters that will be combined with other
#' pivot filters by intersecting their lists of allowed values.
#' @field replaceFilters The PivotFilters that will be combined with other
#' pivot filters by entirely replacing existing PivotFilter objects.
#' @field unionFilters The PivotFilters that will be combined with other
#' pivot filters by unioning their lists of allowed values.
#' @field allFilters The complete set of PivotFilters that will be combined with
#' other pivot filters.

#' @section Methods:
#' \describe{
#'   \item{Documentation}{For more complete explanations and examples please see
#'   the extensive vignettes supplied with this package.}
#'   \item{\code{new(...)}}{Create a new pivot filter overrides object, specifying
#'   the field values documented above.}
#'
#'   \item{\code{add(filter=NULL, variableName=NULL, type="ALL", values=NULL,
#'   action="intersect")}}{Add a pivot filter override, either from an existing
#'   PivotFilter object or by specifying a variableName and values.}
#'   \item{\code{apply(filters)}}{Apply the filter overrides to a PivotFilters
#'   object.}
#'   \item{\code{asList()}}{Get a list representation of this PivotFilterOverrides
#'   object.}
#'   \item{\code{asJSON()}}{Get a JSON representation of this PivotFilterOverrides
#'   object.}
#'   \item{\code{asString(includeVariableName=TRUE, seperator=", ")}}{Get a text
#'   representation of this PivotFilterOverrides object.}
#' }

PivotFilterOverrides <- R6::R6Class("PivotFilterOverrides",
  public = list(
    initialize = function(parentPivot=NULL, removeAllFilters=FALSE, keepOnlyFiltersFor=NULL, removeFiltersFor=NULL, overrideFunction=NULL,
                          filter=NULL, variableName=NULL, type="ALL", values=NULL, action="replace") {
      if(parentPivot$argumentCheckMode > 0) {
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", parentPivot, missing(parentPivot), allowMissing=FALSE, allowNull=FALSE, allowedClasses="PivotTable")
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", removeAllFilters, missing(removeAllFilters), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", keepOnlyFiltersFor, missing(keepOnlyFiltersFor), allowMissing=TRUE, allowNull=TRUE, allowedClasses="character")
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", removeFiltersFor, missing(removeFiltersFor), allowMissing=TRUE, allowNull=TRUE, allowedClasses="character")
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", overrideFunction, missing(overrideFunction), allowMissing=TRUE, allowNull=TRUE, allowedClasses="function")
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", filter, missing(filter), allowMissing=TRUE, allowNull=TRUE, allowedClasses="PivotFilter")
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", variableName, missing(variableName), allowMissing=TRUE, allowNull=TRUE, allowedClasses="character")
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", type, missing(type), allowMissing=TRUE, allowNull=FALSE, allowedClasses="character", allowedValues=c("ALL", "VALUES", "NONE"))
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", values, missing(values), allowMissing=TRUE, allowNull=TRUE, mustBeAtomic=TRUE)
        checkArgument(parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "initialize", action, missing(action), allowMissing=TRUE, allowNull=FALSE, allowedClasses="character", allowedValues=c("intersect", "replace", "union"))
      }
      private$p_parentPivot <- parentPivot
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotFilterOverrides$new", "Creating new Pivot Filter Overrides...",
                                                                               list(removeAllFilters=removeAllFilters, keepOnlyFiltersFor=keepOnlyFiltersFor, removeFiltersFor=removeFiltersFor,
                                                                                    filter=ifelse(is.null(filter), NULL, filter$asString()),
                                                                                    variableName=variableName, type=type, values=values, action=action))
      private$p_removeAllFilters=removeAllFilters
      private$p_keepOnlyFiltersFor=keepOnlyFiltersFor
      private$p_removeFiltersFor=removeFiltersFor
      private$p_overrideFunction <- overrideFunction
      private$p_intersectFilters <- list()
      private$p_replaceFilters <- list()
      private$p_unionFilters <- list()
      if(!missing(filter)) self$add(filter=filter, action=action)
      else if(!missing(variableName)) self$add(variableName=variableName, type=type, values=values, action=action)
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotFilterOverrides$new", "Created new Pivot Filter Overrides.")
    },
    add = function(filter=NULL, variableName=NULL, type="ALL", values=NULL, action="replace") {
      if(private$p_parentPivot$argumentCheckMode > 0) {
        checkArgument(private$p_parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "add", filter, missing(filter), allowMissing=TRUE, allowNull=TRUE, allowedClasses="PivotFilter")
        checkArgument(private$p_parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "add", variableName, missing(variableName), allowMissing=TRUE, allowNull=TRUE, allowedClasses="character")
        checkArgument(private$p_parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "add", type, missing(type), allowMissing=TRUE, allowNull=FALSE, allowedClasses="character", allowedValues=c("ALL", "VALUES", "NONE"))
        checkArgument(private$p_parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "add", values, missing(values), allowMissing=TRUE, allowNull=TRUE, mustBeAtomic=TRUE)
        checkArgument(private$p_parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "add", action, missing(action), allowMissing=TRUE, allowNull=FALSE, allowedClasses="character", allowedValues=c("intersect", "replace", "union"))
      }
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotFilterOverrides$add", "Adding filter override...")
      if(missing(filter)&&missing(variableName))
        stop("PivotFilterOverrides$add():  Either the filter parameter or the variableName parameter must be specified.", call. = FALSE)
      if(is.null(filter)) filter <- PivotFilter$new(private$p_parentPivot, variableName=variableName, type=type, values=values)
      if(action=="intersect") private$p_intersectFilters[[length(private$p_intersectFilters)+1]] <- filter
      else if(action=="replace") private$p_replaceFilters[[length(private$p_replaceFilters)+1]] <- filter
      else if(action=="union") private$p_unionFilters[[length(private$p_unionFilters)+1]] <- filter
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotFilterOverrides$add", "Added filter override.")
    },
    apply = function(filters=NULL, cell=NULL) {
      if(private$p_parentPivot$argumentCheckMode > 0) {
        checkArgument(private$p_parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "apply", filters, missing(filters), allowMissing=FALSE, allowNull=FALSE, allowedClasses="PivotFilters")
        checkArgument(private$p_parentPivot$argumentCheckMode, TRUE, "PivotFilterOverrides", "apply", cell, missing(cell), allowMissing=TRUE, allowNull=TRUE, allowedClasses="PivotCell")
      }
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotFilterOverrides$add", "Applying overrides...")
      if(private$p_removeAllFilters) filters$clearFilters()
      if(length(private$p_keepOnlyFiltersFor)>0) filters$keepOnlyFiltersFor(private$p_keepOnlyFiltersFor)
      if(length(private$p_removeFiltersFor)>0) filters$removeFiltersFor(private$p_removeFiltersFor)
      if(!is.null(private$p_intersectFilters)) {
        if(length(private$p_intersectFilters)>0) {
          for(i in 1:length(private$p_intersectFilters)) {
            filters$setFilter(filter=private$p_intersectFilters[[i]], action="intersect")
          }
        }
      }
      if(!is.null(private$p_replaceFilters)) {
        if(length(private$p_replaceFilters)>0) {
          for(i in 1:length(private$p_replaceFilters)) {
            filters$setFilter(filter=private$p_replaceFilters[[i]], action="replace")
          }
        }
      }
      if(!is.null(private$p_unionFilters)) {
        if(length(private$p_unionFilters)>0) {
          for(i in 1:length(private$p_unionFilters)) {
            filters$setFilter(filter=private$p_unionFilters[[i]], action="union")
          }
        }
      }
      if(!is.null(private$p_overrideFunction)) private$p_overrideFunction(private$p_parentPivot, filters, cell)
      if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotFilterOverrides$add", "Applied overrides.")
    },
    asList = function() {
      lst <- list()
      lstAnd <- list()
      lstReplace <- list()
      lstOr <- list()
      if(length(private$p_intersectFilters) > 0) {
        for (i in 1:length(private$p_intersectFilters)) {
          lstAnd[[i]] = private$p_intersectFilters[[i]]$asList()
        }
      }
      lst$andFilters <- lstAnd
      if(length(private$p_replaceFilters) > 0) {
        for (i in 1:length(private$p_replaceFilters)) {
          lstReplace[[i]] = private$p_replaceFilters[[i]]$asList()
        }
      }
      lst$replaceFilters <- lstReplace
      if(length(private$p_unionFilters) > 0) {
        for (i in 1:length(private$p_unionFilters)) {
          lstOr[[i]] = private$p_unionFilters[[i]]$asList()
        }
      }
      lst$orFilters <- lstOr
      return(invisible(lst))
    },
    asJSON = function() { return(jsonlite::toJSON(self$asList())) },
    asString = function(includeVariableName=TRUE, seperator=", ") {
      if(private$p_parentPivot$argumentCheckMode > 0) {
        checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotFilters", "asString", includeVariableName, missing(includeVariableName), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
        checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotFilters", "asString", seperator, missing(seperator), allowMissing=TRUE, allowNull=FALSE, allowedClasses="character")
      }
      fstr <- ""
      sep <- ""
      if(private$p_removeAllFilters) {
        if(nchar(fstr) > 0) { sep <- seperator }
        fstr <- paste0(fstr, sep, "remove all existing")
      }
      if(length(private$p_keepOnlyFiltersFor)>0) {
        if(nchar(fstr) > 0) { sep <- seperator }
        fstr <- paste0(fstr, sep, "keep only: ", paste(private$p_keepOnlyFiltersFor, collapse=","))
      }
      if(length(private$p_removeFiltersFor)>0) {
        if(nchar(fstr) > 0) { sep <- seperator }
        fstr <- paste0(fstr, sep, "remove: ", paste(private$p_removeFiltersFor, collapse=","))
      }
      if(length(private$p_intersectFilters)>0) {
        for(i in 1:length(private$p_intersectFilters)) {
          if(nchar(fstr) > 0) { sep <- seperator }
          f <- private$p_intersectFilters[[i]]
          fstr <- paste0(fstr, sep, "intersect: ", f$asString(includeVariableName=includeVariableName))
        }
      }
      if(length(private$p_replaceFilters)>0) {
        for(i in 1:length(private$p_replaceFilters)) {
          if(nchar(fstr) > 0) { sep <- seperator }
          f <- private$p_replaceFilters[[i]]
          fstr <- paste0(fstr, sep, "replace: ", f$asString(includeVariableName=includeVariableName))
        }
      }
      if(length(private$p_unionFilters)>0) {
        for(i in 1:length(private$p_unionFilters)) {
          if(nchar(fstr) > 0) { sep <- seperator }
          f <- private$p_unionFilters[[i]]
          fstr <- paste0(fstr, sep, "union: ", f$asString(includeVariableName=includeVariableName))
        }
      }
      return(fstr)
    }
  ),
  active = list(
    removeAllFilters = function(value) { return(invisible(private$p_removeAllFilters)) },
    keepOnlyFiltersFor = function(value) { return(invisible(private$p_keepOnlyFiltersFor)) },
    removeFiltersFor = function(value) { return(invisible(private$p_removeFiltersFor)) },
    overrideFunction = function(value) { return(invisible(private$overrideFunction)) },
    countAnd = function(value) { return(invisible(length(private$p_intersectFilters))) },
    countReplace = function(value) { return(invisible(length(private$p_replaceFilters))) },
    countOr = function(value) { return(invisible(length(private$p_unionFilters))) },
    countTotal = function(value) { return(invisible(length(private$p_intersectFilters)+length(private$p_replaceFilters)+length(private$p_unionFilters))) },
    andFilters = function(value) { return(invisible(private$p_intersectFilters)) },
    replaceFilters = function(value) { return(invisible(private$p_replaceFilters)) },
    orFilters = function(value) { return(invisible(private$p_unionFilters)) },
    allFilters = function(value) { return(invisible(union(private$p_intersectFilters, private$p_replaceFilters, private$p_unionFilters))) }
  ),
  private = list(
    p_parentPivot = NULL,
    p_removeAllFilters = NULL,
    p_keepOnlyFiltersFor = NULL,
    p_removeFiltersFor = NULL,
    p_overrideFunction = NULL,
    p_intersectFilters = NULL,
    p_replaceFilters = NULL,
    p_unionFilters = NULL
  )
)
