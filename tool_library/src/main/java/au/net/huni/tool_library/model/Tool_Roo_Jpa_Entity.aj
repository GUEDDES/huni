// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package au.net.huni.tool_library.model;

import au.net.huni.tool_library.model.Tool;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Version;

privileged aspect Tool_Roo_Jpa_Entity {
    
    declare @type: Tool: @Entity;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long Tool.id;
    
    @Version
    @Column(name = "version")
    private Integer Tool.version;
    
    public Long Tool.getId() {
        return this.id;
    }
    
    public void Tool.setId(Long id) {
        this.id = id;
    }
    
    public Integer Tool.getVersion() {
        return this.version;
    }
    
    public void Tool.setVersion(Integer version) {
        this.version = version;
    }
    
}
