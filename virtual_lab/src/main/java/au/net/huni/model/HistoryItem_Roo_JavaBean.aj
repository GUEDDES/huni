// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package au.net.huni.model;

import au.net.huni.model.HistoryItem;
import au.net.huni.model.Researcher;
import au.net.huni.model.ToolParameter;
import java.util.Calendar;
import java.util.Set;

privileged aspect HistoryItem_Roo_JavaBean {
    
    public String HistoryItem.getToolName() {
        return this.toolName;
    }
    
    public void HistoryItem.setToolName(String toolName) {
        this.toolName = toolName;
    }
    
    public String HistoryItem.getBackgroundColour() {
        return this.backgroundColour;
    }
    
    public void HistoryItem.setBackgroundColour(String backgroundColour) {
        this.backgroundColour = backgroundColour;
    }
    
    public Calendar HistoryItem.getExecutionDate() {
        return this.executionDate;
    }
    
    public void HistoryItem.setExecutionDate(Calendar executionDate) {
        this.executionDate = executionDate;
    }
    
    public Researcher HistoryItem.getOwner() {
        return this.owner;
    }
    
    public Set<ToolParameter> HistoryItem.getToolParameters() {
        return this.toolParameters;
    }
    
    public void HistoryItem.setToolParameters(Set<ToolParameter> toolParameters) {
        this.toolParameters = toolParameters;
    }
    
}
