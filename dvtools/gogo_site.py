# Select UVM_REV
UVM_REV   = '1_1d'

# PLI files
PLI_FILES = ['/nfs/cacadtools/springsoft/Verdi-201307/share/PLI/VCS/LINUX/novas.tab',
             '/nfs/cacadtools/springsoft/Verdi-201307/share/PLI/VCS/LINUX/pli.a']

VCS_VERSION = 'H-2013.06'  # G-2012.09-SP1-1
BUILD_TOOL = 'runmod -m synopsys-vcs_mx/%s vcs' % VCS_VERSION
VCOMP_DIR  = 'sim/.vcomp'

BUILD_OPTIONS = '-q -debug_pp -notice -timescale=1ns/1ps -sverilog +libext+.v+.sv'
BUILD_OPTIONS += ' +define+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR'
BUILD_OPTIONS += '  -CFLAGS -DVCS'

###############
# LSF Command
LSF_SUBMIT_TOOL = 'qrsh'

# Build Licenses
LSF_BUILD_LICS = '-l lic_cmp_vcs'

# Simulation Licenses
LSF_SIM_LICS = '-l lic_sim_vcs'

# Additional Options
LSF_OPTIONS = '-N test'
