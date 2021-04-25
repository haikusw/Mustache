//
//  AttributedMustacheNode.swift
//  mustache
//
//  Created by Helge Heß on 25.04.21.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

#if canImport(Foundation)
import class Foundation.NSAttributedString

/// One node of the Mustache template. A template is parsed into a tree of the
/// various nodes.
public enum AttributedMustacheNode {
  
  case empty
  
  /// Represents the top-level node of a Mustache template, contains the list
  /// of nodes.
  case global([ AttributedMustacheNode])
  
  /// Regular CDATA in the template
  case text(NSAttributedString)
  
  /// A section, can be either a repetition (if the value evaluates to a
  /// Sequence) or a conditional (if the value resolves to true/false).
  /// If the value is false or an empty list, the contained nodes won't be
  /// rendered.
  /// If the value is a Sequence, the contained items will be rendered n-times,
  /// once for each member. The rendering context is changed to the item before
  /// rendering.
  /// If the value is not a Sequence, but considered 'true', the contained nodes
  /// will get rendered once.
  ///
  /// A Mustache section is introduced with a "{{#" tag and ends with a "{{/"
  /// tag.
  /// Example:
  ///
  ///     {{#addresses}}
  ///       Has address in: {{city}}
  ///     {{/addresses}}
  ///
  case section(String, [ AttributedMustacheNode ])
  
  /// An inverted section either displays its contents or not, it never repeats.
  ///
  /// If the value is 'false' or an empty list, the contained nodes will get
  /// rendered.
  /// If it is 'true' or a non-empty list, it won't get rendered.
  ///
  /// An inverted section is introduced with a "{{^" tag and ends with a "{{/"
  /// tag.
  /// Example:
  ///
  ///     {{^addresses}}
  ///       The person has no addresses assigned.
  ///     {{/addresses}}
  ///
  case invertedSection(String, [ AttributedMustacheNode ])
  
  /// A Mustache Variable. Will try to lookup the given string as a name in the
  /// current context. If the current context doesn't have the name, the lookup
  /// is supposed to continue at the parent contexts.
  ///
  /// The resulting value will be HTML escaped.
  ///
  /// Example:
  ///
  ///     {{city}}
  ///
  case tag(NSAttributedString)
  
  /// This is the same like Tag, but the value won't be HTML escaped.
  ///
  /// Use triple braces for unescaped variables:
  ///
  ///     {{{htmlToEmbed}}}
  ///
  /// Or use an ampersand, like so:
  ///
  ///     {{^ htmlToEmbed}}
  ///
  case unescapedTag(NSAttributedString)
  
  /// A partial. How this is looked up depends on the rendering context
  /// implementation.
  ///
  /// Partials are included via "{{>", like so:
  ///
  ///     {{#names}}
  ///       {{> user}}
  ///     {{/names}}
  ///
  case partial(String)
}
#endif // canImport(Foundation)
