import com.intellij.navigation {
    NavigationItem,
    ItemPresentationProviders
}
import com.intellij.openapi.project {
    Project
}
import com.intellij.pom {
    Navigatable
}
import com.redhat.ceylon.ide.common.model {
    SourceFile
}
import com.redhat.ceylon.model.typechecker.model {
    Declaration
}

import org.intellij.plugins.ceylon.ide.ceylonCode.resolve {
    CeylonReference
}

shared class DeclarationNavigationItem(shared Declaration decl, shared Project project)
        satisfies NavigationItem {

    canNavigate() => true;

    canNavigateToSource() => decl.unit is SourceFile;

    name => decl.name;

    shared actual void navigate(Boolean requestFocus) {
        if (exists resolved = CeylonReference.resolveDeclaration(decl, project),
            is Navigatable resolved) {
            resolved.navigate(requestFocus);
        } else if (is SourceFile unit = decl.unit) {
            // TODO open file
        }
    }

    presentation => ItemPresentationProviders.getItemPresentation(this);

    shared actual Boolean equals(Object that) {
        if (is DeclarationNavigationItem that) {
            return decl==that.decl &&
                project==that.project;
        }
        else {
            return false;
        }
    }

    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + decl.hash;
        hash = 31*hash + project.hash;
        return hash;
    }

}
