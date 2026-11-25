"""LibreLane plugin for the GNSS AFE + megabytebeat dual-VDD chip."""
import os
from librelane.steps.step import Step
from librelane.steps.odb import OdbpyStep


@Step.factory.register()
class GnssAnalogStraps(OdbpyStep):
    """
    Straps:
      1. Analog pad block (afe_rf_pad) + analog[0..2] -> gnss_afe_analog on Metal2.
      2. megabytebeat_macro VDD_BB (Metal5 C-trunk + 6x fill10_supplyVDD jumpers)
         and shared VSS (Metal4 + Via3 to South VSS M3 ring & North M3 collector bar).
    """

    id = "Odb.GnssAnalogStraps"
    name = "GNSS analog & megabytebeat power straps"

    def get_script_path(self):
        return os.path.join(os.path.dirname(__file__), "analog_straps.py")


@Step.factory.register()
class DisconnectBbVdd(OdbpyStep):
    """
    Clears Floorplan's global VDD binding on VDD_BB-domain pads before Odb.SetPowerConnections
    so they bind cleanly to VDD_BB instead of GNSS VDD.
    """

    id = "Odb.DisconnectBbVdd"
    name = "Disconnect GNSS VDD from VDD_BB pads"

    def get_script_path(self):
        return os.path.join(os.path.dirname(__file__), "disconnect_bb_vdd.py")
