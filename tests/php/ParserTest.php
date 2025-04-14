<?php

use PHPUnit\Framework\TestCase;

class ParserTest extends TestCase
{
    private $parser;

    protected function setUp(): void
    {
        $this->parser = new StandaloneParser();
    }

    public function testBasicFormatting()
    {
        $html = $this->parser->parse("'''Bold''' and ''italic''");
        $this->assertStringContainsString('<strong>Bold</strong>', $html);
        $this->assertStringContainsString('<em>italic</em>', $html);
    }

    public function testLinks()
    {
        $result = $this->parser->parseWithMetadata('[[Main Page|Home]]');
        $this->assertStringContainsString('<a href="Main_Page">Home</a>', $result['text']);
        $this->assertArrayHasKey('Main_Page', $result['links']);
    }

    public function testHeaders()
    {
        $wikitext = "== Section 1 ==\nText\n=== Subsection ===\nMore text";
        $result = $this->parser->parseWithMetadata($wikitext);
        
        $this->assertStringContainsString('<h2', $result['text']);
        $this->assertStringContainsString('<h3', $result['text']);
        $this->assertGreaterThan(0, count($result['sections']));
    }

    public function testLists()
    {
        $wikitext = "* Item 1\n* Item 2\n** Subitem";
        $html = $this->parser->parse($wikitext);
        
        $this->assertStringContainsString('<ul>', $html);
        $this->assertStringContainsString('<li>', $html);
        // Should have nested list
        $this->assertGreaterThan(
            strpos($html, '<ul>'),
            strrpos($html, '<ul>')
        );
    }

    public function testTables()
    {
        $wikitext = "{|\n|+ Caption\n|-\n! Header 1 !! Header 2\n|-\n| Cell 1 || Cell 2\n|}";
        $html = $this->parser->parse($wikitext);
        
        $this->assertStringContainsString('<table', $html);
        $this->assertStringContainsString('<caption>Caption</caption>', $html);
        $this->assertStringContainsString('<th', $html);
        $this->assertStringContainsString('<td', $html);
    }

    public function testImages()
    {
        $wikitext = '[[File:example.jpg|thumb|Caption text]]';
        $result = $this->parser->parseWithMetadata($wikitext);
        
        $this->assertContains('example.jpg', $result['images']);
        $this->assertStringContainsString('Caption text', $result['text']);
    }

    public function testCategories()
    {
        $wikitext = "Text\n[[Category:Test]]\n[[Category:Example]]";
        $result = $this->parser->parseWithMetadata($wikitext);
        
        $this->assertArrayHasKey('Test', $result['categories']);
        $this->assertArrayHasKey('Example', $result['categories']);
    }

    public function testTemplates()
    {
        $wikitext = '{{Template|param=value}}';
        $result = $this->parser->parseWithMetadata($wikitext);
        
        $this->assertArrayHasKey('Template', $result['templates']);
    }

    public function testErrorHandling()
    {
        // Test invalid wikitext
        $html = $this->parser->parse("'''Unmatched bold");
        $this->assertIsString($html);

        // Test empty input
        $html = $this->parser->parse("");
        $this->assertIsString($html);

        // Test null input
        $this->expectException(TypeError::class);
        $this->parser->parse(null);
    }

    public function testSpecialCharacters()
    {
        $html = $this->parser->parse("&amp; &lt; &gt;");
        $this->assertStringContainsString('&amp;', $html);
        $this->assertStringContainsString('&lt;', $html);
        $this->assertStringContainsString('&gt;', $html);

        // Test Unicode
        $html = $this->parser->parse("Unicode: ñ é ü");
        $this->assertStringContainsString('ñ', $html);
        $this->assertStringContainsString('é', $html);
        $this->assertStringContainsString('ü', $html);
    }

    public function testLargeContent()
    {
        $wikitext = str_repeat("'''Test''' paragraph\n", 1000);
        $html = $this->parser->parse($wikitext);
        
        $this->assertGreaterThan(10000, strlen($html));
        $this->assertStringContainsString('<strong>Test</strong>', $html);
    }
}