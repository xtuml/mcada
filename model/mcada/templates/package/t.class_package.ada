-- class package:  ${self.name}
-- description:  self.description

package ${root_package.name}.${domain_package.name}.${self.name} is

--**************  Object ${self.long_name} Information **************

Object_String : String := "${self.name}";

${record_body}

end ${root_package.name}.${domain_package.name}.${self.name};
