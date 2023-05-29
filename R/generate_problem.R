# named list for replacement
operation_lookup <- c("Addition" = "+",
                      "Subtraction" = "-",
                      "Multiplication" = "&times;", 
                      "Division" = "&div;")

# Generate math problems
#' Generate Problem
#' 
#' Creates a random math problem fitting the provided criteria.
#'
#' @param range1 A vector of values for the first operand, e.g. 1:10
#' @param range2 A vector of values for the second operand, e.g. 1:10
#' @param operations A vector of operations, e.g. c("Addition","Subtraction")
#' @param allow_negatives If subtraction is the operation, allow negative results
#' @param div_remainders If division is the operation, allow results with a remainder
#'
#' @return A character string with a randomly generated math problem
#' @export
#'
#' @examples
generate_problem <- function(range1,range2,operations,allow_negatives = F, div_remainders = F) {
  
  operand1 <- ifelse(length(range1) == 1, range1, sample(range1,1))
  operand2 <- ifelse(length(range2) == 1, range2, sample(range2,1))
  operation <- ifelse(length(operations) == 1, operations, sample(operations,1))
  
  # rerolls for subtraction - negative answers
  if (all(!allow_negatives, operand2 > operand1, operation == "Subtraction")) {
    while (operand2 > operand1) {
      operand1 <- ifelse(length(range1) == 1, range1, sample(range1,1))
      operand2 <- ifelse(length(range2) == 1, range2, sample(range2,1))
    }
  }
  
  # rerolls for division
  # no divide by zero plz
  if (all(operation == "Division", operand2 == 0)) {
    operand2 <- 1
  }
  # reroll if we don't want remainders
  if (all(!div_remainders, operand1 %% operand2 != 0, operation == "Division")) {
    while (operand1 %% operand2 != 0) {
      operand1 <- ifelse(length(range1) == 1, range1, sample(range1,1))
      operand2 <- ifelse(length(range2) == 1, range2, sample(range2,1))
      # no divide by zero in the reroll plskthx -- yes this is stupid. I will come up with a better way.
      if (operand2 == 0) operand2 <- 1
    }
  }
  
  paste(operand1, operation_lookup[operation], operand2, "=")
  
}
