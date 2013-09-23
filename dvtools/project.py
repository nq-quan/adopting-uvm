###############
# UVM Options

# Select UVM_REV
UVM_REV   = '1_1d'

# Special PLI files
PLI_FILES = []

###############
# Use runmod? (Cavium only)
USE_RUNMOD = 1

###############
# How to build with VCS
VCS_VERSION = 'H-2013.06'
BUILD_MODS = ["synopsys-vcs_mx/%s" % VCS_VERSION]
BUILD_TOOL = 'vcs'
VCOMP_DIR  = 'sim/.vcomp'

# VCS Build Options
BUILD_OPTIONS = '-q -debug_pp -notice -timescale=1ns/1ps -sverilog +libext+.v+.sv'
BUILD_OPTIONS += ' +define+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR'
BUILD_OPTIONS += '  -CFLAGS -DVCS'

###############
# Various VCS Flags
SIM_GUI = ' -gui'
SIM_MODS = ['synopsys-vcs_mx/%s' % VCS_VERSION]

###############
# Simulation options
SIM_WAVE_OPTIONS = ''

###############
# LSF Command
LSF_SUBMIT_TOOL = 'qrsh'

# Build Licenses
LSF_BUILD_LICS = '-l lic_cmp_vcs'

# Simulation Licenses
LSF_SIM_LICS = '-l lic_sim_vcs'

################
# How to Clean Up
CLEAN_DIRS = ('sim', 'csrc', 'DVEfiles')
CLEAN_FILES = ('ucli.key', 'vc_hdrs.h')
