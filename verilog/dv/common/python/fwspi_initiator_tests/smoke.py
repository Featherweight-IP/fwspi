'''
Created on Apr 10, 2021

@author: mballance
'''

import cocotb
import pybfms
from wishbone_bfms.wb_initiator_bfm import WbInitiatorBfm
from gpio_bfms.GpioBfm import GpioBfm
from spi_bfms.spi_target_bfm import SpiTargetBfm

@cocotb.test()
async def entry(dut):
    print("Hello")
    await pybfms.init()
    
    reg_bfm : WbInitiatorBfm = pybfms.find_bfm(".*u_reg_bfm", WbInitiatorBfm)
    irq_bfm : GpioBfm = pybfms.find_bfm(".*u_irq_bfm", GpioBfm)
    spi_bfm : SpiTargetBfm = pybfms.find_bfm(".*u_spi_bfm")

    dat = await reg_bfm.read(0x0)
    dat |= 0xC0 # Enable
    dat = await reg_bfm.write(0x0, dat, 0xF)
    
    recv_data = 0
   
    def recv_data_cb(data):
        nonlocal recv_data
        recv_data = data
    spi_bfm.recv_f = recv_data_cb
        

    for i in range(10):
        
        # Send data 
        send_dat = 0x5A + i
        await reg_bfm.write(0x8, send_dat, 0xF)

        # Wait for an interrupt
        while True:
            val = await irq_bfm.on_in()
        
            if val:
                break
    
        
        dat = await reg_bfm.read(0x4) # status
        dat |= 0x8 # clear IRQ
        await reg_bfm.write(0x4, dat, 0xF) # status
        
        if send_dat != recv_data:
            raise Exception("Expect " + hex(send_dat) + " receive " + hex(recv_data))
        
        print("Done: data=" + str(recv_data))
    
    await cocotb.triggers.Timer(1, units="ms")
    