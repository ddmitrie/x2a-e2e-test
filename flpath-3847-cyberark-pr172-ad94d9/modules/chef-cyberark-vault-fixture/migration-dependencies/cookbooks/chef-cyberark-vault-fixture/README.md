# Chef CyberArk/Conjur credential fixture

This minimal cookbook is test data for FLPATH-3847. It contains placeholder
Conjur lookups and passes the resulting values to a Chef `template` resource.
No real CyberArk, Conjur, or application credential is included.

Expected analysis marker:

`FLPATH-3847 credential migration test`
