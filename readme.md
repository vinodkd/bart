bart: the bash application rapid tester
========================================

bart is a simple tool that helps in testing command line applications. It happens to be called __bash__ application rapid tester, but it can be used to test any command line application.

Unline xunit test tools, however, bart doesn't try to do unit testing - its more of an acceptance test tool - if such a concept could apply to command line apps. bart doesnt actually run inside your app, but models success or failure purely on the return value of the process itself. What it __does__ do, however, is to allow executing the app under test with multiple inputs and validate that the output is as expected. Specifically, it allows modeling failure as an accepted response for invalid input.

Here's a sample run to show the concept. The application under test is "echo", and we're sending it a set of numbers.

      $ cat inputs
      function getinputs()
      {
        INPUTS=( 1 2 3 4 5 )
      }
      $ ./bart echo
      Running: echo 1
      1
      execution: "echo 1", return: 0, outcome: PASSED
      Running: echo 2
      2
      execution: "echo 2", return: 0, outcome: PASSED
      Running: echo 3
      3
      execution: "echo 3", return: 0, outcome: PASSED
      Running: echo 4
      4
      execution: "echo 4", return: 0, outcome: PASSED
      Running: echo 5
      5
      
      Ran command: "echo 5", which returned: 0. Is this the expected result (y/n)?
      n
      execution: "echo 5", return: 0, outcome: FAILED
      
      bart summary for runs of "echo" :
      execution: "echo 1", return: 0, outcome: PASSED
      execution: "echo 2", return: 0, outcome: PASSED
      execution: "echo 3", return: 0, outcome: PASSED
      execution: "echo 4", return: 0, outcome: PASSED
      execution: "echo 5", return: 0, outcome: FAILED
      
      $ cat expected_results.tsv
      echo 1  0
      echo 3  0
      echo 4  0
      echo 2  0

As you can see:
- the inputs are supplied via a script that bart sources in. the `inputs` file is expected to have a `getinputs()` function that sets a global `INPUTS` array with the inputs to be used with the command.
- invoking bart with the name of the executable to be run then causes bart to run that executable with each supplied input in order.
- as it goes through each input, bart also asks if the return value was the expected one; and records the accepted values for future use
- it finally displays a summary of all the outcomes (which could be different from the return value itself)

Note:
- The return values that are accepted by the user as expected outcome are stored in a file called `expected_values.tsv` in the current working directory
- You can add or delete at any time to this file directly to make bart skip the interactive prompt
- You can also delete the tsv file to make bart "forget" previous responses.

How to use bart for your own testing
====================================
- download the bart script, and copy it to the directory where your app is, or where you want the expected_results.tsv to be stored.
  - note that bart will append to any existing tsv file, so you might want to copy bart to separate folders for each app to be tested
- create an inputs file that creates an array of inputs that you want bart to send to the executable to be tested
- call bart with the executable as a param

Next steps
==========
- add a -y switch to bart to treat all prompt-able points as a yes answer automatically
- add a -n switch to bart to treat all prompt-able points as a no answer automatically
