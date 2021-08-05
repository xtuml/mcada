-- class package:  ${self.name}
-- description:  self.description

.if ( "" != domain_types_package_name )
with ${domain_types_package_name};
.end if

package ${root_package.name}.${domain_package.name}.${self.name} is

--**************  Object ${self.long_name} Information **************

Object_String : String := "${self.name}";

${record_body}

end ${root_package.name}.${domain_package.name}.${self.name};
