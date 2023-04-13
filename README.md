# Github Action for AWS Evidence Collection

> When you use this. The project should be private for obvious reasons.



#### Evidence That will be collected:


| Evidence                                                     | Github Action                                         | Evidence Output                                    | SOC2 Mapping               | NIST Mapping |
| :----------------------------------------------------------- | ----------------------------------------------------- | -------------------------------------------------- | :------------------------- | ------------ |
| Inbound network access to server management ports is controlled and restricted to defined sources |                                                       |                                                    | CC6.1, CC6.3, CC6.6, CC6.7 |              |
| The default configuration of server network access is restricted and denies all access |                                                       |                                                    | CC6.1, CC6.3, CC6.6, CC6.7 |              |
| Buckets have delete protection enabled to protect bucket deletion |                                                       |                                                    | CC6.1, CC6.3, CC6.6, CC6.7 |              |
| Public access to buckets is restricted to prevent uncontrolled or unauthorized access |                                                       |                                                    | CC6.1, CC6.3, CC6.6, CC6.7 |              |
| Network access to buckets is restricted to disallow non-conforming traffic and protocols such as HTTP |                                                       |                                                    | CC6.1, CC6.3, CC6.6, CC6.7 |              |
| Inbound network access to management ports is controlled and restricted to defined sources |                                                       |                                                    | CC6.1, CC6.3, CC6.6, CC6.7 |              |
| Web Application Firewall (WAF) rules are configured to protect network access |                                                       |                                                    | CC6.1                      |              |
| Load balancers have only HTTPS/SSL listeners to enforce encryption in transit | [YAML](/.github/workflows/load-bal-ssl-config.yaml)   | [OUTPUT](/Configurations/load-bal-ssl-config.yaml) | CC6.1, CC6.3, CC6.6, CC6.7 |              |
| Load balancers have delete protection enabled to protect from deletion |                                                       |                                                    | CC6.1, CC6.3, CC6.6, CC6.7 |              |
| Database backups are encrypted to prevent unauthorized access to information |                                                       |                                                    | CC6.7                      |              |
| Encryption configuration for databases used in production environments |                                                       |                                                    | CC6.7                      |              |
| Encryption configuration for server disks used in production environments |                                                       |                                                    | CC6.7                      |              |
| Server disk backups are encrypted to prevent unauthorized access to information |                                                       |                                                    | CC6.7                      |              |
| Encryption configuration for buckets used in production environments |                                                       |                                                    | CC6.7                      |              |
| Encryption keys are rotated frequently to mitigate the risk of unauthorized access to cryptographic keys |                                                       |                                                    | CC1.1                      |              |
| Listings of access keys, secret keys, API keys and other cryptographic keys stored on the key management server |                                                       |                                                    |                            |              |
| TLS certificate of the production application proving confidential traffic. | [YAML](/.github/workflows/list-tls-certificates.yaml) | [OUTPUT](/Lists/tls-certificates.yaml)             |                            |              |
|                                                              |                                                       |                                                    |                            |              |
|                                                              |                                                       |                                                    |                            |              |
|                                                              |                                                       |                                                    |                            |              |















