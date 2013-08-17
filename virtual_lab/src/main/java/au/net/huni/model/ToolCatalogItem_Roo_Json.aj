// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package au.net.huni.model;

import au.net.huni.model.ToolCatalogItem;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect ToolCatalogItem_Roo_Json {
    
    public String ToolCatalogItem.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static ToolCatalogItem ToolCatalogItem.fromJsonToToolCatalogItem(String json) {
        return new JSONDeserializer<ToolCatalogItem>().use(null, ToolCatalogItem.class).deserialize(json);
    }
    
    public static String ToolCatalogItem.toJsonArray(Collection<ToolCatalogItem> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<ToolCatalogItem> ToolCatalogItem.fromJsonArrayToToolCatalogItems(String json) {
        return new JSONDeserializer<List<ToolCatalogItem>>().use(null, ArrayList.class).use("values", ToolCatalogItem.class).deserialize(json);
    }
    
}
