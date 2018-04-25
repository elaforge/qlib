#!/usr/bin/python2.4
#
# Copyright 2006 Google Inc. All Rights Reserved.

"""Command line quixote client

  q_test.py [flags] /path/to/object var1=val1 var2=val2 @ \
    /path/to/another/object var3=val3 var4=val4 ...

Example:
  $ ./q_test.py --app_dir=~/tmp/test-tp \
      --setup_test=~/src/google3/ops/hardware/touchpad/test/setup_replay.py \
      / __passwd=test __login=test @ \
      /wh
"""

__author__ = 'elaforge'

from google3.ops.common import seq
from google3.ops.common.quixote import quixote_browser
from google3.ops.common.quixote import replay
from google3.pyglib import app
from google3.pyglib import flags

FLAGS = flags.FLAGS

flags.DEFINE_boolean('print_headers', False, 'print headers')
flags.DEFINE_boolean('raw_output', False, 'do not format output')
flags.DEFINE_string('env_vars', '', 'HTTP env variables to pass to request')


def main(argv):
  if len(argv) < 2:
    raise RuntimeError, 'path must be supplied'

  env = {}
  if FLAGS.env_vars:
    env = seq.DictList(e.split('=') for e in FLAGS.env_vars.split(','))

  setup_module = replay.PrepareReplayEnvironment()

  publisher = setup_module['Publisher']()
  browser = quixote_browser.Browser(publisher)

  for cmd in seq.SplitWith(lambda e: e == '@', argv[1:]):
    if cmd[-1] == '@':
      del cmd[-1]
    path = cmd[0]
    args = cmd[1:]
    form = seq.DictList(a.split('=') for a in args)
    out, headers = browser.Query(path, form, env)
    if FLAGS.print_headers:
      print headers
    if FLAGS.raw_output:
      print out
    else:
      print quixote_browser.Html(out, headers)

  return 0


if __name__ == '__main__':
  app.run()
