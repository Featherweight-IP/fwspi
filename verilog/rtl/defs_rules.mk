
FWSPI_INITIATOR_RTL_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

ifeq (,$(findstring $(FWSPI_INITIATOR_RTL_DIR),$(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(FWSPI_INITIATOR_RTL_DIR)

include $(PACKAGES_DIR)/fwprotocol-defs/verilog/rtl/defs_rules.mk

MKDV_VL_SRCS += $(wildcard $(FWSPI_INITIATOR_RTL_DIR)/*.v)

endif

else # Rules

endif
