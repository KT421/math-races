test_that("div by zero", {
  expect_equal(generate_problem(1,0,"Division"),
  "1 &div; 1 =")
})

test_that("no remainders division", {
  expect_equal(generate_problem(10,4:5,"Division"),
               "10 &div; 5 =")
})

