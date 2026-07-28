## Re-export the generic that endogCopulaPanel extends (validity.copregpanel)
## but does not define itself, so that a user who attaches only
## endogCopulaPanel can call validity() without also loading endogCopula.
#' @importFrom endogCopula validity
#' @export
endogCopula::validity

## NAMESPACE completeness. R/copreg-panel.R calls nobs(), .lm.fit() and
## ave() unqualified; DESCRIPTION lists 'stats' under Imports, but that
## alone does not put these names in scope -- unqualified lookups inside a
## package's own namespace never fall through to the search path, so a
## session in which 'stats' has not been attached (R CMD check's clean
## reload, or any R_DEFAULT_PACKAGES override) fails with "could not find
## function". nobs() additionally needs registerS3method to find the
## generic while loading the namespace, which importFrom also provides.
#' @importFrom stats nobs .lm.fit ave
NULL
