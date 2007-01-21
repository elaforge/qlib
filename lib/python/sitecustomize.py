import sys, os, local.qtraceback
def ehook(typ, val, tb):
	sys.stdout.write(''.join(
		local.qtraceback.format_exception(typ, val, tb)))
sys.excepthook = ehook
local.qtraceback.Install()

def SetupPackageAccess(*a):
  # that bastion of brokenness, pyglib.app and pyglib.flags, likes to pretend
  # this does something
  pass

# import google sitecustomize which does *lots* of path setup crap
# XXX this is icky
# execfile('/home/build/public/google/setup/sitecustomize.py')
# execfile('/home/elaforge/lib/python/gsc.py')
