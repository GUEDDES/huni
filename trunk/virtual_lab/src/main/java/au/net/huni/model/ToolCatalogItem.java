package au.net.huni.model;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.ManyToMany;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.hibernate.proxy.HibernateProxyHelper;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.jpa.activerecord.RooJpaActiveRecord;
import org.springframework.roo.addon.json.RooJson;
import org.springframework.roo.addon.tostring.RooToString;

@RooJavaBean
@RooToString
@RooJpaActiveRecord
@RooJson
public class ToolCatalogItem {

    @NotNull
    @Column(unique = true)
    @Size(min = 5, max = 64)
    private String name;

    private String description;

    @NotNull
    private String url;

    @NotNull
    @ManyToMany
    private Set<ToolCategory> categories = new HashSet<ToolCategory>();

	public String toString() {
        return this.name;
    }
    
    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        } else if (!(HibernateProxyHelper.getClassWithoutInitializingProxy(obj).equals(ToolCatalogItem.class))) {
            return false;
        }

        ToolCatalogItem candidate = (ToolCatalogItem) obj;

        return this.getName().equals(candidate.getName())
                && this.getUrl().equals(candidate.getUrl())
            ;
    }
    
    @Override
    public int hashCode() {
        return this.getName().hashCode()
                + this.getUrl().hashCode()
             ;
    }
}
