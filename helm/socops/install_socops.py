#!/usr/bin/env python3

'''
 NAME: install_socops.py | version: 0.1
 MAYA Version: 0.1
 AUTHOR: Diego Perez (@darkquasar) - 2019
 DESCRIPTION: Helper python script to install SocOps KB 
 
 Updates: 
    v0.1: ---.
    
 ToDo:
    1. ----.

'''

import argparse
import logging
import os
import sys
import time
from datetime import datetime as datetime
from pathlib import Path
from time import strftime

# Setup logging
logger = logging.getLogger('SOCOPS')
formatter = logging.Formatter('%(asctime)s - %(name)s - %(message)s')
console_handler = logging.StreamHandler()
console_handler.setFormatter(formatter)
console_handler.setLevel(logging.DEBUG)
logger.addHandler(console_handler)
logger.setLevel(logging.DEBUG)

class Arguments(object):
    
  def __init__(self, args):
    self.parser = argparse.ArgumentParser(
        description="XML to JSON Document Converter"
        )
    

    self.parser.add_argument(
        "-a", "--action",
        help="This option determines what action will be executed by MAYA: parse, hunt or learn (ML)",
        type=str,
        choices=["collect", "hunt", "learn", "parse"],
        default="parse",
        required=False
        )

    self.pargs = self.parser.parse_args()
      
  def get_args(self):
    return self.pargs

def gen_passwords(yamldict):
  # This function will generate passwords  

  return passwd

def main():
  args = Arguments(sys.argv)
  pargs = args.get_args()
  
  # Capturing start time for debugging purposes
  st = datetime.now()
  starttime = strftime("%Y-%m-%d %H:%M:%S", time.localtime())
  logger.info("Starting MAYA Hunting Framework")
  
  # Something Here
    
  # Capturing end time for debugging purposes
  et = datetime.now()
  endtime = strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    
  hours, remainder = divmod((et-st).seconds, 3600)
  minutes, seconds = divmod(remainder, 60)

  logger.info("Finished Parsing")
  logger.info('Took: \x1b[47m \x1b[32m{} hours / {} minutes / {} seconds \x1b[0m \x1b[39m'.format(hours,minutes,seconds))

if __name__ == '__main__':
    try:
        main()
        sys.exit()
    
    except KeyboardInterrupt:
        print("\n" + "I've been interrupted by a mortal" + "\n\n")

        sys.exit()