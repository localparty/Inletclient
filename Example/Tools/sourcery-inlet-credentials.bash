#!/usr/bin/env bash -ex
if [ "$#" -ne 1 ]; then
     >&2 echo "illegal number of parameters, expected a Bash file exporting '${INLET_USERNAME}' and '${INLET_PASSWORD}'";
    exit 1;
fi
INLET_CREDS=$1;

#check if the source exists exists
source "${INLET_CREDS}";
if [[ $? -ne 0 ]]
then
    >&2 echo "couldn't load the credentials, try again?"
    exit 2;
fi
# sourcery generates a swift file with the credentials
"${PODS_ROOT}/Sourcery/bin/sourcery" \
  --verbose \
  --sources \
  	"./Inletclient/InletCredentials.stencil" \
  --templates \
  	"./Inletclient/" \
  --output \
    "./Inletclient" \
  --args \
  	"inletusername=${INLET_USERNAME},inletpassword=${INLET_PASSWORD}" \
;