
VERILOG_DV_COMMON_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
FWSPI_INITIATOR_DIR := $(abspath $(VERILOG_DV_COMMON_DIR)/../../..)
PACKAGES_DIR := $(FWSPI_INITIATOR_DIR)/packages
DV_MK := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)

ifneq (1,$(RULES))

include $(FWSPI_INITIATOR_DIR)/verilog/rtl/defs_rules.mk

MKDV_PYTHONPATH += $(VERILOG_DV_COMMON_DIR)/python

include $(DV_MK)
else # Rules

include $(DV_MK)
endif
