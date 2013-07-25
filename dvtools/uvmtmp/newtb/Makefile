#-*- mode: makefile;-*-
# ******************************************************************************
# * CAVIUM CONFIDENTIAL
# *
# *                         PROPRIETARY NOTE
# *
# *  
# * This software contains information confidential and proprietary
# * to Cavium.  It shall not be reproduced in whole or in
# * part, or transferred to other documents, or disclosed to third
# * parties, or used for any purpose other than that for which it was
# * obtained, without the prior written consent of Cavium.
# * (c) <year>, Cavium.  All rights reserved.
# * (utg v<utgversion>)
# *
# ******************************************************************************
# * File        : <filename>
# * Author      : <author>
# * Description : <TB> Makefile
# *
# ******************************************************************************

################################################################################
#################### Define some internal helper variables #####################
################################################################################

ROOT_DIR     ?= ../..
TB_ROOT      =./$(TB_NAME)_tb_top.sv
PROJECT_MODE =UVM
SIMULATOR    = VCS

ifndef DVTOOLS_DIR
export DVTOOLS_DIR := $(shell find_dvtools)
endif

CSR_PKGS = $(ROOT_DIR)/verif/vkits/csr/auto_generated/csr_<TB>_pkg.sv

FLISTS= verif/vkits/cn/cn.flist \
   verif/vkits/global/global.flist \
	verif/<TB>/<TB>.flist \
	verif/<TB>/rtl.flist

SCOVROOT = $(ROOT_DIR)/rtl/$(TB_NAME)/$(TB_NAME).v

ICTCOVSELECT = $(HDL_TOP).$(TB_NAME).*...

#-------------------------------------------------------------------------------

# Specify libraries required, only if they have C++, csr.py, or other build steps
# Generic vkits that just provide an flist do not go in this list
TB_XDIRS = ../regs
TB_XDIRS_FULL += ../uvm_common
TB_XDIRS_VKIT =  ../vkits/uvm/$(UVMREV)/src/uvm_dpi

TB_LIBS = $(addprefix uvm_common.,$(subst $(COMMA), ,$(SIMULATOR)))

ifeq ($(LIB),TB)
INC_DIRS = . $(OBJ_DIR)/unit
BASE=Tb
SRC_DIRS=tb
endif

ifeq ($(LIB),TEST)
INC_DIRS = . ./tb $(OBJ_DIR)/unit $(OBJ_DIR)/unitTb
BASE=Test
SRC_DIRS=tests
endif

ifdef LIB
include $(DVTOOLS_DIR)/lib/Makefile.lib
else
include $(DVTOOLS_DIR)/lib/Makefile.sim
endif
