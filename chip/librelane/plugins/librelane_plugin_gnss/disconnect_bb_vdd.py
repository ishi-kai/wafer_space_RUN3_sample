"""odbpy: disconnect Floorplan's global-connect VDD binding on VDD_BB-domain pads
so Odb.SetPowerConnections cleanly binds them to VDD_BB."""
import re
from reader import click_odb, click

BB_PAD_RX = re.compile(r"^(bb_|dvdd_bb_pads|dvss_bb_pads|nc_bb|sup_vdd_)")


@click.command()
@click_odb
def main(reader):
    block = reader.block
    block.clearGlobalConnect()
    n = 0
    for inst in block.getInsts():
        name = inst.getName().replace("\\", "")
        if not BB_PAD_RX.match(name):
            continue
        for pin in ("VDD", "DVDD"):
            it = inst.findITerm(pin)
            if it is not None and it.getNet() is not None:
                it.disconnect()
                n += 1
    print(f"[INFO] DisconnectBbVdd: cleared globalConnect rules and disconnected {n} VDD/DVDD pins on VDD_BB pads")


if __name__ == "__main__":
    main()
