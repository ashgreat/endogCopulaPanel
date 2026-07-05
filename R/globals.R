# The bootstrap worker bootst1() deliberately reads these objects from its
# enclosing environment: CopRegML_par() builds a self-contained environment
# and ships it to the cluster workers via parallel::clusterExport(). Declare
# them so R CMD check does not flag "no visible binding" notes.

#' @importFrom utils globalVariables
NULL

globalVariables(c("Estimate", "ecdf", "f1", "f1X_m", "f1Z", "formula",
                  "method", "samples1"))
