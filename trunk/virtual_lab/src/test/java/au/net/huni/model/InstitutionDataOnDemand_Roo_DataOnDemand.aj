// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package au.net.huni.model;

import au.net.huni.model.Institution;
import au.net.huni.model.InstitutionDataOnDemand;

privileged aspect InstitutionDataOnDemand_Roo_DataOnDemand {
    
    public void InstitutionDataOnDemand.setCode(Institution obj, int index) {
        String code = "code_" + index;
        obj.setCode(code);
    }
    
}
