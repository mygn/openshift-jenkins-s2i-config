#!/usr/bin/env python
import os
import sys
from xml.etree import ElementTree as et

NAMESPACE = "http://maven.apache.org/POM/4.0.0"

def updateVersion(elementName, newVersion, path='pom.xml'):
    et.register_namespace('', NAMESPACE)
    tree = et.ElementTree()
    assert os.path.exists(path), "Cannot find %s" % (path)

    tree.parse(path)
    p = tree.getroot().find("{%s}properties" % NAMESPACE)
    assert p, "key properties doesn't exist in %s" % (path)

    e = p.find("{%s}%s" % (NAMESPACE, elementName))
    assert e.text, "key %s doesn't exist in the properties of %s" % (
        elementName, path)
    e.text = newVersion
    tree.write(path)

if __name__ == '__main__':
    updateVersion(*sys.argv[1:3])
