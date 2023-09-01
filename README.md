# WiFi Check

[WiFi/Check](https://wificheck.app) is a simple app that displays information about the WiFi connections
made from your Mac.  In the upgrade from Big Sur to Monterrey, Apple changed the
permissions on the data file - so it now requires a password to access and any
modifications to the file will require a password to make the change.  This also
uses the command line utility <code class="small">networksetup</code> for reading preferred order
and to remove a WiFi network from the list and if you want to see the password for
the WiFi Network stored in your Keychain, it will prompt for a password there, too.

I built this mostly as an exercise to learn SwiftUI and scratch an itch.

