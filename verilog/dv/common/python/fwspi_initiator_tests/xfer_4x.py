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
    await pybfms.init()
    
    reg_bfm : WbInitiatorBfm = pybfms.find_bfm(".*u_reg_bfm", WbInitiatorBfm)
    irq_bfm : GpioBfm = pybfms.find_bfm(".*u_irq_bfm", GpioBfm)
    spi_bfm : SpiTargetBfm = pybfms.find_bfm(".*u_spi_bfm")

    dat = await reg_bfm.read(0x0)
    dat |= 0xC0 # Enable
    dat = await reg_bfm.write(0x0, dat, 0xF)
    
    recv_data = []

    # Collect the data received   
    def recv_data_cb(data):
        nonlocal recv_data
        print("recv_data_cb: " + hex(data))
        recv_data.append(data)
    spi_bfm.recv_f = recv_data_cb
        

    count = 10
    i = 0
    while i < count:
        
        # Send data in blocks of 4
        start_i = i
        for x in range(4):
            if i < count:
                send_dat = 0x5A + i
                await reg_bfm.write(0x8, send_dat, 0xF)
                i += 1

        # Wait for an interrupt
        for x in range(i-start_i):
            while True:
                val = await irq_bfm.on_in()
        
                dat = await reg_bfm.read(0x4) # status
                dat |= 0x8 # clear IRQ
                await reg_bfm.write(0x4, dat, 0xF) # status
                
                if val:
                    break

        # Check data
        for x in range(4):
            if start_i < count:
                send_dat = 0x5A + start_i
                recv = recv_data.pop(0)
                
                if send_dat != recv:
                    raise Exception("Expect " + hex(send_dat) + " receive " + hex(recv))
                
                start_i += 1
        
    
    