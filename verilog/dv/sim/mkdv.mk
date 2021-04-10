
MKDV_MK := $(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR := $(dir $(MKDV_MK))

TOP_MODULE = fwspi_initiator_tb
MKDV_VL_SRCS += $(TEST_DIR)/fwspi_initiator_tb.sv

MKDV_PLUGINS += cocotb pybfms
PYBFMS_MODULES += wishbone_bfms gpio_bfms spi_bfms
MKDV_COCOTB_MODULE ?= fwspi_initiator_tests.smoke

include $(TEST_DIR)/../common/defs_rules.mk

RULES := 1

include $(TEST_DIR)/../common/defs_rules.mk
