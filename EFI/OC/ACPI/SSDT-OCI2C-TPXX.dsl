// SSDT-I2C 
DefinitionBlock("", "SSDT", 2, "hack", "I2C-TPXX", 0)
{
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2C0.TPD0, DeviceObj)
    External (GPDI, FieldUnitObj)
    External (SDM0, FieldUnitObj)
    External (SYCN, FieldUnitObj)
    External (SDS0, FieldUnitObj)
    External (TPDH, FieldUnitObj)
    External (TPDB, FieldUnitObj)
    External (TPDS, FieldUnitObj)
    External (_SB_.GNUM, MethodObj)
    External (_SB_.INUM, MethodObj)
    External (_SB_.SHPO, MethodObj)
    External (_SB_.PCI0.HIDD, MethodObj)
    External (_SB_.PCI0.TP7D, MethodObj)
    External (_SB_.PCI0.HIDG, IntObj)
    External (_SB_.PCI0.TP7G, IntObj)

    Scope (\)
    {
        External (SMD1, FieldUnitObj)
        If (_OSI ("Darwin"))
        {
            SMD1 = 0
        }
    }

    Scope (_SB.PCI0.I2C0)
    {
        Device (TPXX)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x002C, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C0",
                    0x00, ResourceConsumer, _Y24, Exclusive,
                    )
            })
            Name (SBFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveLow, ExclusiveAndWake, ,, _Y25)
                {
                    0x00000021,
                }
            })
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x001B
                    }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C0.TPXX._Y24._ADR, BADR)
            CreateDWordField (SBFB, \_SB.PCI0.I2C0.TPXX._Y24._SPE, SPED)
            CreateWordField (SBFG, 0x17, INT1)
            CreateDWordField (SBFI, \_SB.PCI0.I2C0.TPXX._Y25._INT, INT2)
            Method (_INI, 0, Serialized)
            {
                Store (GNUM (GPDI), INT1)
                Store (INUM (GPDI), INT2)
                If (LEqual (SDM0, Zero))
                {
                    SHPO (GPDI, One)
                }

                Switch (SYCN)
                {
                    Case (One)
                    {
                        Store ("DELL0783", _HID)
                    }
                    Case (0x02)
                    {
                        Store ("DELL0784", _HID)
                    }
                    Case (0x03)
                    {
                        Store ("DELL0785", _HID)
                    }
                    Case (0x04)
                    {
                        Store ("DELL0786", _HID)
                    }
                    Case (0x05)
                    {
                        Store ("DELL077F", _HID)
                    }
                    Case (0x06)
                    {
                        Store ("DELL0780", _HID)
                    }
                    Case (0x07)
                    {
                        Store ("DELL0781", _HID)
                    }
                    Case (0x08)
                    {
                        Store ("DELL0782", _HID)
                    }
                    Default
                    {
                        Store ("DELL0783", _HID)
                    }

                }

                If (LEqual (SDS0, One))
                {
                    Store (0x20, HID2)
                    Return (Zero)
                }

                If (LEqual (SDS0, 0x02))
                {
                    Store (0x20, HID2)
                    Return (Zero)
                }

                If (LEqual (SDS0, 0x05))
                {
                    Store (TPDH, HID2)
                    Store (TPDB, BADR)
                    If (LEqual (TPDS, Zero))
                    {
                        Store (0x000186A0, SPED)
                    }

                    If (LEqual (TPDS, One))
                    {
                        Store (0x00061A80, SPED)
                    }

                    If (LEqual (TPDS, 0x02))
                    {
                        Store (0x000F4240, SPED)
                    }

                    Return (Zero)
                }
            }

            Name (_HID, "DELL0783")
            Name (_CID, "PNP0C50")
            Name (_S0W, 0x03)
            Method (_DSM, 4, Serialized)
            {
                If (LEqual (Arg0, HIDG))
                {
                    Return (HIDD (Arg0, Arg1, Arg2, Arg3, HID2))
                }

                If (LEqual (Arg0, TP7G))
                {
                    Return (TP7D (Arg0, Arg1, Arg2, Arg3, SBFB, SBFG))
                }

                Return (Buffer (One)
                {
                     0x00                                           
                })
            }

            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_CRS, 0, NotSerialized)
            {
                Return (ConcatenateResTemplate (SBFB, SBFI))
            }
        }
    }

    //_STA => XSTA 1103010014095F535441 => 11030100140958535441 (5F535441 => 58535441 count 1 skip 27)
    Scope (_SB.PCI0.I2C0.TPD0)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
}
