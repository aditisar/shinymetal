class Resource < ActiveRecord::Base
  RESOURCE_LIST = ['organizations','events','attendees','memberships','positions','users']
  PARAM_NAME_HASH = { organizations: ["organizationId",
                                      "excludeHiddenOrganizations",
                                      "status", "category","type","name"],
                       events: ["eventId",
                                "organizationId",
                                "locationId",
                                "externalLocationId",
                                "currentEventsOnly",
                                "status", "category","type",
                                "name", "startDate", "endDate"],
                       attendees: ["eventId",
                                   "organizationId",
                                   "attendanceId",
                                   "userId", "username",
                                   "attendanceStatus","status",
                                   "includeUnrecognizedUsers",
                                   "includeReflections",
                                   "startDate","endDate"],
                       memberships: ["membershipId",
                                     "userId","username",
                                     "organizationId",
                                     "currentMembershipsOnly",
                                     "publicPrivacyFilter",
                                     "campusPrivacyFilter",
                                     "includeReflections",
                                     "positionTemplateId",
                                     "positionTemplateName",
                                     "startDate","endDate"],
                       positions: ["positionId", "organizationId",
                                   "template","type","activeStatusOnly"],
                       users: ["userId","username","cardId","sisId","affiliation",
                               "enrollmentStatus","primarySchoolOfEnrollment","status"],
                       # These parameters are available to all endpoints
                       # Currently they are unused, just here for documentation purposes
                       all: ["page","pageSize"] }
  PARAM_LIST = PARAM_NAME_HASH::values.flatten.uniq
  
  # Theoretically these could also be temporary, and taken from calls to collegiatelinkapi?
  # FIXME we need to figure out which ones are important. 
  COLUMN_NAME_HASH = { organizations: ["OrganizationId",
                                       "Name",
                                       "Status",
                                       "ShortName",
                                       "Summary",
                                       "Description"
                                       # FIXME there are others for orgs
                                       ],
                       events: ["EventId",
                                   "EventName",
                                   "OrganizationId",
                                   "OrganizationName",
                                   "StartDate",
                                   "EndDate"
                                   # FIXME there are others for events
                                   ],
                       attendees: ["EventId",
                                   "EventName",
                                   "OrganizationId",
                                   "OrganizationName",
                                   "StartDate",
                                   "EndDate",
                                   "AttendanceId",
                                   "UserId"
                                   # FIXME again, what do attendees need?
                                    ],
                       memberships: ["MembershipId",
                                     "OrganizationId",
                                     "OrganizationName",
                                     "OrganizationShortName"
                                    # FIXME there are others for mem too
                                     ],
                       positions: ["positionId",
                                   "positionName",
                                   "positionNameLocked"
                                   #FIXME others for positions too
                                   ],
                       users: ["UserId",
                               "Username",
                               "Status"
                               # FIXME again, there are others for users
                               ] }
  # This isn't used because a columns controller hasn't been created yet
  #COLUMN_LIST = COLUMN_NAME_HASH::values.flatten.uniq
  
end
