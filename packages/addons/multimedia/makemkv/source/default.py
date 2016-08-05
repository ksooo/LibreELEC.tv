################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

import os
import urllib2, re
import xbmc, xbmcaddon
import xbmcgui

# Addon info
__addon__     = xbmcaddon.Addon()
__addonid__   = __addon__.getAddonInfo('id')
__addonname__ = __addon__.getAddonInfo('name')
__author__    = __addon__.getAddonInfo('author')
__version__   = __addon__.getAddonInfo('version')
__cwd__       = __addon__.getAddonInfo('path')

# Settings
APP_KEY  = "app_Key"
CONFPATH = os.path.expanduser('~/.MakeMKV/settings.conf')
CONF     = None
BETAURL  = 'http://www.makemkv.com/forum2/viewtopic.php?f=5&t=1053'
BETAEXP  = re.compile('<div class="codecontent">([^<]*)')

#
# Notify user
#
def notify(msg):
  xbmcgui.Dialog().ok(__addonname__, msg)

#
# Load settings
#
def getAll():
  global CONF
  if CONF is not None:
    return CONF
  ret = {}
  if os.path.exists(CONFPATH):
    exp = re.compile('([^ ]+) = "([^"]*)"')
    for l in open(CONFPATH):
      res = exp.search(l)
      if res:
        ret[res.group(1)] = res.group(2)
  CONF = ret
  return ret

#
# Get specific setting
#
def get(key):
  conf = getAll()
  if key in conf:
    return conf[key]
  return None

#
# Get latest beta key
#
def getBeta():
  headers = { 'User-Agent' : 'Mozilla/5.0' }
  req = urllib2.Request(BETAURL, None, headers)

  for l in urllib2.urlopen(req):
    res = BETAEXP.search(l)
    if res:
      return res.group(1)
  return None

#
# Set setting
#
def set(key, val):

  # Create directories
  dirp = os.path.dirname(CONFPATH)
  if not os.path.exists(dirp):
    os.makedirs(dirp)

  # Create tmp file
  fp = open(CONFPATH + '.tmp', 'w')
  if os.path.exists(CONFPATH):
    for l in open(CONFPATH):
      if l.startswith(key):
        continue
      fp.write(l)
  fp.write('%s = "%s"\n' % (key, val))
  fp.close()

  # Replace
  if os.path.exists(CONFPATH):
    os.unlink(CONFPATH)
  os.rename(CONFPATH + '.tmp', CONFPATH)

#
# Update beta license key
#
def updateBetaLicenseKey():

  # Fetch latest key
  key = getBeta()

  # Key found?
  if not key:
    notify("No beta key found.")
    return False

  # Already up to date?
  cur = get(APP_KEY)
  if cur == key:
    notify("Beta key is up-to-date.")
    return False

  # Write key to settings file
  set(APP_KEY, key)

  notify("New beta key written.")
  return True

# Check and update beta key
updateBetaLicenseKey()

