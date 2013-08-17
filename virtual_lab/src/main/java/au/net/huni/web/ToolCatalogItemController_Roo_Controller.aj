// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package au.net.huni.web;

import au.net.huni.model.ToolCatalogItem;
import au.net.huni.model.ToolCategory;
import au.net.huni.web.ToolCatalogItemController;
import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect ToolCatalogItemController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String ToolCatalogItemController.create(@Valid ToolCatalogItem toolCatalogItem, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, toolCatalogItem);
            return "toolcatalogitems/create";
        }
        uiModel.asMap().clear();
        toolCatalogItem.persist();
        return "redirect:/toolcatalogitems/" + encodeUrlPathSegment(toolCatalogItem.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String ToolCatalogItemController.createForm(Model uiModel) {
        populateEditForm(uiModel, new ToolCatalogItem());
        return "toolcatalogitems/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String ToolCatalogItemController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("toolcatalogitem", ToolCatalogItem.findToolCatalogItem(id));
        uiModel.addAttribute("itemId", id);
        return "toolcatalogitems/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String ToolCatalogItemController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("toolcatalogitems", ToolCatalogItem.findToolCatalogItemEntries(firstResult, sizeNo));
            float nrOfPages = (float) ToolCatalogItem.countToolCatalogItems() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("toolcatalogitems", ToolCatalogItem.findAllToolCatalogItems());
        }
        return "toolcatalogitems/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String ToolCatalogItemController.update(@Valid ToolCatalogItem toolCatalogItem, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, toolCatalogItem);
            return "toolcatalogitems/update";
        }
        uiModel.asMap().clear();
        toolCatalogItem.merge();
        return "redirect:/toolcatalogitems/" + encodeUrlPathSegment(toolCatalogItem.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String ToolCatalogItemController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, ToolCatalogItem.findToolCatalogItem(id));
        return "toolcatalogitems/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String ToolCatalogItemController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        ToolCatalogItem toolCatalogItem = ToolCatalogItem.findToolCatalogItem(id);
        toolCatalogItem.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/toolcatalogitems";
    }
    
    void ToolCatalogItemController.populateEditForm(Model uiModel, ToolCatalogItem toolCatalogItem) {
        uiModel.addAttribute("toolCatalogItem", toolCatalogItem);
        uiModel.addAttribute("toolcategorys", ToolCategory.findAllToolCategorys());
    }
    
    String ToolCatalogItemController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}
