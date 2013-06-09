require 'gcm'

gcm = GCM.new("AIzaSyBrSeCokkG3Eqn0I4B9VNAcmPrVjiaGtIE")
registration_ids= ['APA91bFyzSedoLbvtfn25pqOoL_FAZ-Ja8Au_iA9LN0eW4rEN1ERWvvFU7Csnkca0eP4_S3o98GizBHPMFd5Qc6MG349KvmOSMNbZTl1Y6w4Ph1yCKLeKJl1GWG2O2Twewn0A4K_8JVg'] # an array of one or more client registration IDs
options = {data: {score: "123", test: "asdf", test2: "asdf"}, collapse_key: "updated_score"}
response = gcm.send_notification(registration_ids, options)