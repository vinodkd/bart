bart: the bash application rapid tester
========================================

bart is a simple tool that helps in testing command line applications. It happens to be called __bash__ application rapid tester, but it can be used to test any command line application.

Unline xunit test tools, however, bart doesn't try to do unit testing - its more of an acceptance test tool - if such a concept could apply to command line apps. bart doesnt actually run inside your app, but models success or failure purely on the return value of the process itself. What it __does__ do, however, is to allow executing the app under test with multiple inputs and validate that the output is as expected. Specifically, it allows modeling failure as an accepted response for invalid input.

Here's a sample run to show the concept. The application under test is `sum.sh`, and we're sending it a set of number pairs to add.

      $ cat sum.sh
      if [[ $# -ne 2 ]]; then
        exit -1
      fi
      echo "input:$1 and $2"
      let sum=$1+$2
      echo $sum

... to whom we'll provide the following inputs:

      $ cat inputs
      1 2
      3 4
      5 6
      
... by running bart thus:

      $ ./bart ./sum.sh ./inputs
      bart started.
      Running: ./sum.sh 1 2
      input:1 and 2
      3
      
      Ran command: "./sum.sh 1 2", which returned: 0. Is this the expected result (y/n)?
      y
      execution of: "./sum.sh 1 2" returned: 0 and outcome: PASSED
      Running: ./sum.sh 3 4
      input:3 and 4
      7
      
      Ran command: "./sum.sh 3 4", which returned: 0. Is this the expected result (y/n)?
      y
      execution of: "./sum.sh 3 4" returned: 0 and outcome: PASSED
      Running: ./sum.sh 5 6
      input:5 and 6
      11
      
      Ran command: "./sum.sh 5 6", which returned: 0. Is this the expected result (y/n)?
      y
      execution of: "./sum.sh 5 6" returned: 0 and outcome: PASSED
      
      bart summary for runs of "./sum.sh" :
      execution of: "./sum.sh" returned: 0 and outcome: PASSED
      execution of: "./sum.sh" returned: 0 and outcome: PASSED
      execution of: "./sum.sh" returned: 0 and outcome: PASSED
      bart done.
      
... the outcomes and our acceptance of the outcomes is stored in `bart_test_log.tsv`

      $ cat bart_test_log.tsv
      ./sum.sh 1 2	0
      ./sum.sh 3 4	0
      ./sum.sh 5 6	0

Now, adding another line to the input to test the case where one of the inputs is missed, like so:
    
      $ cat inputs
      1 2
      3 4
      5 6
      7

... and then running bart again would result in the following run:

      $ ./bart ./sum.sh ./inputs
      bart started.
      Running: ./sum.sh 1 2
      input:1 and 2
      3
      execution of: "./sum.sh 1 2" returned: 0 and outcome: PASSED
      Running: ./sum.sh 3 4
      input:3 and 4
      7
      execution of: "./sum.sh 3 4" returned: 0 and outcome: PASSED
      Running: ./sum.sh 5 6
      input:5 and 6
      11
      execution of: "./sum.sh 5 6" returned: 0 and outcome: PASSED
      Running: ./sum.sh 7
      
      Ran command: "./sum.sh 7", which returned: 255. Is this the expected result (y/n)?
      y
      execution of: "./sum.sh 7" returned: 255 and outcome: PASSED
      
      bart summary for runs of "./sum.sh" :
      execution of: "./sum.sh" returned: 0 and outcome: PASSED
      execution of: "./sum.sh" returned: 0 and outcome: PASSED
      execution of: "./sum.sh" returned: 0 and outcome: PASSED
      execution of: "./sum.sh" returned: 255 and outcome: PASSED
      bart done.

Note that the last execution failed - as expected; and that this was stored as a "PASSED" by bart.
Also:
- The return values that are accepted by the user as expected outcome are stored in a file called `bart_test_log.tsv` in the current working directory
- You can add or delete at any time to this file directly to make bart skip the interactive prompt
- You can also delete the tsv file to make bart "forget" previous responses.

How to use bart for your own testing
====================================
- download the bart script, and copy it to the directory where your app is, or where you want the `bart_test_log.tsv` to be stored.
  - note that bart will append to any existing tsv file, so you might want to copy bart to separate folders for each app to be tested
- create an inputs file that has one line per for each set of inputs you'd like to send to the app under test.
- optionally add a `bart_fixture.sh` and write a setup() and/or teardown() function in it. these will be called once per iteration.
- call bart with the executable as a param

Next steps
==========
- add a -y switch to bart to treat all prompt-able points as a yes answer automatically
- add a -n switch to bart to treat all prompt-able points as a no answer automatically
