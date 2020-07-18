import isce

def testStripmapReaders():
    from isceobj.Sensor import SENSORS
    for k,v in SENSORS.items():
        print('Stripmap Sensor: {0}'.format(k))
        obj = v()

def testTOPSReaders():
    from isceobj.Sensor.TOPS import SENSORS
    for k,v in SENSORS.items():
        print('TOPS Sensor: {0}'.format(k))
        obj = v()

def testGeometryModules():
    from zerodop.topozero.Topozero import Topo
    from zerodop.geo2rdr.Geo2rdr import Geo2rdr
    from zerodop.geozero.Geozero import Geocode

def testCythonOpenCV():
    from contrib.splitSpectrum import SplitRangeSpectrum

def testAutoRIFT():
    from contrib.geo_autoRIFT.autoRIFT import autoRIFT
    from contrib.geo_autoRIFT.autoRIFT import autoRIFT_ISCE
    from contrib.geo_autoRIFT.geogrid import Geogrid
    from contrib.geo_autoRIFT.geogrid import GeogridOptical

def testMultiModeReaders():
    from isceobj.Sensor.MultiMode import SENSORS
    for k,v in SENSORS.items():
        print('MultiMode Sensor: {0}'.format(k))
        obj = v()

if __name__ == '__main__':

    # testStripmapReaders() XXX needs cmake cosar support
    testTOPSReaders()
    testGeometryModules()
    testCythonOpenCV()
    testMultiModeReaders()
    # testAutoRIFT() XXX needs autoRIFT setup
